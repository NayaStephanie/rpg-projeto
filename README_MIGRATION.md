# Migração de Dados para Firestore (RPGo)

Este documento descreve os passos para migrar os dados locais do app para o Firestore, validar a publicação das regras e reverter caso necessário. Você pediu que este arquivo fique separado do `README.md` principal.

**Importante**: sempre faça backup antes de qualquer migração.

**Onde o app grava backup local**
- O app gera backups JSON locais (quando solicitado pela tela de migração). Procure na pasta de documentos do app ou na pasta de exportação indicada na UI no momento do backup.

**Visão geral do fluxo de migração (in-app)**
1. Abra o app e faça login com o usuário alvo.
2. Vá em `Migração de dados` no menu (tela `MigrationScreen`).
3. Clique em `Fazer backup local` (gera um arquivo JSON). Salve este arquivo em outro local seguro antes de prosseguir.
4. Use a função `Enviar para a nuvem` (ou equivalente) para subir personagens/inventário para `usuarios/{uid}/characters` e `usuarios/{uid}/inventories`.
   - A migração evita duplicatas verificando `nameLower` e usando `merge: true` quando apropriado.
5. Verifique a coleção no console do Firebase para confirmar os documentos.

**Campos auxiliares necessários**
- Para busca case-insensitive e ordenação, os documentos devem possuir campos auxiliares `nameLower` (para personagens) e `itemNameLower` (para itens). A `MigrationScreen` adiciona estes campos quando ausentes.

**Publicar/atualizar `firestore.rules` (CLI)**
- Caso precise publicar ou atualizar regras manualmente, use o Firebase CLI. No PowerShell, a sequência típica é:

```powershell
Set-Location -Path 'C:\Users\Naya\OneDrive\Desktop\projeto-rpg\app_rpg'
firebase login
# Se não tiver configurado o projeto localmente:
# firebase use --add
firebase deploy --only firestore:rules
```

- Verifique no Console do Firebase > Firestore > Regras para confirmar que as regras foram atualizadas.

**Recomendações de rollback**
- Se algo der errado, importe o JSON de backup pelo script/funcionalidade de restauração (se disponível) ou re-crie os documentos manualmente a partir do arquivo JSON.
- Você também pode apagar documentos indevidos no Console do Firebase e reexecutar a migração após ajustar os dados locais.

**Checklist de verificação pós-migração**
- [ ] Verificar que cada usuário tem apenas seus documentos em `usuarios/{uid}/...`.
- [ ] Testar pesquisa na `FirestoreSearchScreen` e confirmar resultados.
- [ ] Abrir algumas fichas no `FirestoreCharactersListScreen` para garantir renderização correta.
- [ ] Testar criação de novo personagem: deve salvar localmente e tentar sincronizar com Firestore.
- [ ] Testar edição/exclusão de inventário: alterações devem refletir no Firestore (quando online).

**Atenção a formatos de timestamp**
- Documentos do Firestore podem usar `Timestamp` nativo. O app tenta tratar `Timestamp` e strings de data ao converter para `DateTime`.

**Notas sobre segurança**
- As regras de Firestore foram configuradas para restringir acesso a `usuarios/{uid}/...` ao respectivo usuário autenticado. Confirme no Console do Firebase se o ID do projeto correto está sendo usado.

**Como eu (assistente) posso ajudar mais**
- Posso adicionar um link no `README.md` principal apontando para este arquivo.
- Posso gerar um script de restauração automática a partir do backup JSON (opcional).
- Posso documentar testes manuais detalhados e registrar resultados.

---
Arquivo criado: `README_MIGRATION.md` (na raiz do projeto `app_rpg`).
