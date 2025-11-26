<#
firestore_patch_restore.ps1

Uso rápido:
- Backup + Patch simples (usa gcloud token):
  .\firestore_patch_restore.ps1 -ProjectId my-project -Uid userUid -DocId docId -Updates "name=Novo Nome","level=5"

- Patch usando arquivo JSON (Firestore REST format for "fields"):
  .\firestore_patch_restore.ps1 -ProjectId my-project -Uid userUid -DocId docId -PatchFile .\patch_body.json

- Restaurar a partir de backup gerado:
  .\firestore_patch_restore.ps1 -ProjectId my-project -Uid userUid -DocId docId -RestoreBackup .\backup_docid_2025-11-24T12-00-00.json

Atenção:
- Requer Google Cloud SDK (`gcloud`) no PATH para obter token via `gcloud auth print-access-token`.
- Não comitar chaves de serviço. Para uso em CI, prefira ativar conta de serviço localmente e rodar `gcloud auth activate-service-account --key-file=key.json`.

O script faz:
1) Obtém token via `gcloud auth print-access-token`.
2) Faz GET do documento e salva backup em JSON (timestamped) antes de aplicar alteração.
3) Aplica PATCH com UPDATE MASK para os campos fornecidos.
4) Pode restaurar usando o backup salvo.
#>
param(
    [Parameter(Mandatory=$true)] [string]$ProjectId,
    [Parameter(Mandatory=$true)] [string]$Uid,
    [Parameter(Mandatory=$true)] [string]$DocId,
    [string[]]$Updates,        # formato: "name=Novo Nome","level=5"
    [string]$PatchFile,        # caminho para arquivo JSON com { "fields": { ... } }
    [string]$RestoreBackup     # caminho para arquivo backup (restaura o documento inteiro)
)

function Get-AccessToken {
    try {
        $token = & gcloud auth print-access-token 2>$null
        if (-not $token) { throw "gcloud não retornou token. Faça 'gcloud auth login' ou ative conta de serviço." }
        return $token.Trim()
    } catch {
        Write-Error "Erro obtendo token via gcloud: $_"
        return $null
    }
}

$token = Get-AccessToken
if (-not $token) { Write-Error "Token não disponível. Abortando."; exit 1 }

$baseUrl = "https://firestore.googleapis.com/v1/projects/$ProjectId/databases/(default)/documents/usuarios/$Uid/characters/$DocId"

# Função para salvar backup do documento atual
function Backup-Document {
    param([string]$url, [string]$token)
    try {
        $resp = Invoke-RestMethod -Method Get -Uri $url -Headers @{ Authorization = "Bearer $token" }
        $ts = (Get-Date).ToString('s').Replace(':','-')
        $filename = "backup_${DocId}_${ts}.json"
        $resp | ConvertTo-Json -Depth 20 | Out-File -FilePath $filename -Encoding UTF8
        Write-Output $filename
    } catch {
        Write-Error "Falha ao obter documento: $_"
        return $null
    }
}

# Se RestoreBackup foi informado, restaura e sai
if ($RestoreBackup) {
    if (-not (Test-Path $RestoreBackup)) { Write-Error "Arquivo de backup não encontrado: $RestoreBackup"; exit 1 }
    $body = Get-Content $RestoreBackup -Raw
    try {
        # PATCH sem updateMask para substituir (merge behavior depende do corpo enviado). Usamos PATCH para escrever fields.
        $resp = Invoke-RestMethod -Method Patch -Uri "$baseUrl" -Headers @{ Authorization = "Bearer $token"; 'Content-Type' = 'application/json' } -Body $body
        Write-Host "Restauração aplicada com sucesso." -ForegroundColor Green
        exit 0
    } catch {
        Write-Error "Erro ao restaurar: $_"
        exit 1
    }
}

# Backup atual
$backupFile = Backup-Document -url $baseUrl -token $token
if (-not $backupFile) { Write-Error "Não foi possível gerar backup. Abortando."; exit 1 }
Write-Host "Backup salvo em: $backupFile"

# Prepara corpo do PATCH
if ($PatchFile) {
    if (-not (Test-Path $PatchFile)) { Write-Error "PatchFile não encontrado: $PatchFile"; exit 1 }
    $body = Get-Content $PatchFile -Raw
    # Optional: user-provided file is expected to be in Firestore REST format: { "fields": { ... } }
    $fieldKeys = (ConvertFrom-Json $body).fields.PSObject.Properties.Name
} elseif ($Updates) {
    $fields = @{}
    $fieldPaths = @()
    foreach ($u in $Updates) {
        if ($u -notmatch '=' ) { Write-Warning "Ignorando update inválido: $u"; continue }
        $parts = $u -split '='
        $key = $parts[0].Trim()
        $val = ($parts[1..($parts.Length-1)] -join '=').Trim()
        $fieldPaths += $key
        # Detecta inteiro simples
        if ($val -match '^-?\d+$') {
            $fields[$key] = @{ integerValue = "$val" }
        } else {
            $fields[$key] = @{ stringValue = "$val" }
        }
    }
    $payload = @{ fields = $fields }
    $body = $payload | ConvertTo-Json -Depth 10
} else {
    Write-Error "Nenhuma atualização fornecida. Use -Updates ou -PatchFile ou -RestoreBackup."; exit 1
}

# monta query string updateMask se tivermos fieldPaths list
$updateMaskParams = ''
if ($fieldPaths) {
    $pairs = $fieldPaths | ForEach-Object { "updateMask.fieldPaths=$($_)" }
    $updateMaskParams = '?' + ($pairs -join '&')
}

$patchUrl = "$baseUrl$updateMaskParams"
try {
    $resp = Invoke-RestMethod -Method Patch -Uri $patchUrl -Headers @{ Authorization = "Bearer $token"; 'Content-Type' = 'application/json' } -Body $body
    Write-Host "Patch aplicado com sucesso." -ForegroundColor Green
    Write-Host "Backup salvo em: $backupFile"
    Write-Host "Resposta: "
    $resp | ConvertTo-Json -Depth 10
    exit 0
} catch {
    Write-Error "Falha ao aplicar patch: $_"
    Write-Host "Você pode restaurar usando: .\firestore_patch_restore.ps1 -ProjectId $ProjectId -Uid $Uid -DocId $DocId -RestoreBackup $backupFile"
    exit 1
}
