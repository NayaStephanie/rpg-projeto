# Checklist de Testes Manuais — app_rpg (RPGo)

Este documento descreve um conjunto de testes manuais para validar a integração Firestore/local, migração, pesquisa, API e regras de segurança.

Preparação
- Ambiente: Windows (PowerShell), Flutter configurado, Firebase CLI logado.
- Projeto: abra `app_rpg` no editor e tenha um emulador/dispositivo disponível.
- Comandos úteis:

```powershell
# Entrar na pasta do projeto
Set-Location -Path 'C:\Users\Naya\OneDrive\Desktop\projeto-rpg\app_rpg'
# Rodar o app no dispositivo/emulador
flutter run
# Publicar regras (quando necessário)
firebase deploy --only firestore:rules
```

1) Autenticação
- Objetivo: validar cadastro/login/recuperação de senha.
- Passos:
  - Abra o app e crie um usuário (email/senha).
  - Verifique que a criação cria o documento em `usuarios/{uid}` (no Console do Firebase).
  - Faça logout e login com o mesmo usuário.
  - Use a opção de recuperar senha para confirmar envio de e-mail.
- Resultado esperado: cadastro e login funcionam; documento de usuário criado; e-mail de recuperação enviado.

2) Backup local e migração (fluxo in-app)
- Objetivo: validar backup JSON e envio para Firestore via `MigrationScreen`.
- Passos:
  - No dispositivo, crie alguns personagens localmente (não autenticado/ou com usuário autenticado se preferir).
  - Abra `Migração de dados` e clique em `Fazer backup local` -> salve o arquivo em local externo (copie para PC).
  - Em seguida, execute `Enviar para a nuvem` (com login no usuário destino).
  - No Console do Firebase, verifique `usuarios/{uid}/characters` e `usuarios/{uid}/inventories`.
- Resultado esperado: backup JSON gerado; documentos criados no Firestore; campos auxiliares (`nameLower`/`itemNameLower`) adicionados.

3) Criação de personagem (local-first + sync)
- Objetivo: garantir que `AddCharacterScreen` salve localmente e tente sincronizar na nuvem.
- Passos:
  - Crie um personagem (com usuário autenticado) usando a tela `AddCharacterScreen`.
  - Observe mensagens/feedback — deve confirmar salvamento local e, se online e usuário logado, sincronizar na nuvem.
  - No Console do Firebase, confirme o documento em `usuarios/{uid}/characters`.
  - Desconecte rede e crie outro personagem; reconecte e verifique comportamento de sincronização (indicador/retry no `CharacterSheet`).
- Resultado esperado: personagem salvo localmente; quando online, sincroniza; indicador de sync aparece se houver falha com opção de retry.

4) Edição e exclusão (local + cloud)
- Objetivo: verificar update/delete no Firestore e fallback local.
- Passos:
  - Abra um personagem hospedado na nuvem e edite campos (nome, nível, equipamento).
  - Salve e confirme as mudanças no Console do Firebase.
  - Exclua um personagem hospedado e confirme remoção do documento do Firestore.
  - Faça a mesma operação em um personagem local e verifique que a remoção é local.
- Resultado esperado: updates e deletes são refletidos no Firestore quando aplicável; fallback local funciona sem crashes.

5) Inventário
- Objetivo: validar `AddInventoryScreen`, fallback (`InventoryStorageService`) e edição em nuvem.
- Passos:
  - Adicione itens ao inventário com e sem autenticação.
  - Verifique itens salvos localmente (SharedPreferences) e na coleção `usuarios/{uid}/inventories` quando online.
  - Teste edição/exclusão de item na interface de gestão de inventários na nuvem.
- Resultado esperado: itens aparecem na origem correta; falhas de rede não perdem dados locais.

6) Pesquisa (FirestoreSearchScreen)
- Objetivo: testar busca case-insensitive e ordenação.
- Passos:
  - Garanta que alguns documentos na nuvem possuem o campo `nameLower` (ou rode a migração).
  - Use `FirestoreSearchScreen` para buscar por parte do nome (minúsculas/maiúsculas) e validar resultados.
- Resultado esperado: buscas retornam documentos esperados independentemente do case.

7) Consumo de API e cache (Dnd5eService)
- Objetivo: testar chamadas à API DnD e o cache em SharedPreferences.
- Passos:
  - Abra `Monstros DnD` e carregue a lista; observe tempo de carregamento inicial.
  - Saia e reabra a tela; verifique se os dados foram carregados do cache (mais rápidos) quando dentro do TTL (24h).
- Resultado esperado: primeira chamada atinge API; chamadas subsequentes dentro de 24h usam cache.

8) Regras de segurança do Firestore
- Objetivo: confirmar que regras publicadas restringem acesso por UID.
- Passos:
  - No Console do Firebase, confirme as regras publicadas (ou rode deploy manualmente).
  - Tente ler/escrever com outro usuário ou sem autenticação (pode usar um cliente separado ou modo incognito do app, se disponível).
- Resultado esperado: somente o usuário proprietário consegue acessar seus documentos em `usuarios/{uid}/...`.

9) Rollback / restauração de backup
- Objetivo: garantir que o backup JSON possa ser usado para restaurar dados em caso de erro.
- Passos:
  - A partir do arquivo JSON de backup gerado anteriormente, execute o procedimento de restauração (se tiver ferramenta de restauração) ou inspecione manualmente e re-crie documentos no Console.
- Resultado esperado: dados restauráveis a partir do backup JSON.

10) Logs e captura de problemas
- Oriente a captura de logs: use `flutter run` no terminal e cole o output de exceções. Para erros no Firebase, verifique o Log do Cloud ou mensagens no Console do Firebase.

---

12) Validação em tempo real (Streams)

Objetivo: validar que as views que usam `StreamBuilder` recebem atualizações em tempo real do Firestore para as coleções `characters` e `inventories`.

Passos rápidos (resumo):
- Abra o app com um usuário autenticado.
- Navegue até as telas que usam streams: `Personagens (Nuvem)` / tela de Inventário (Nuvem) / `Pesquisar Personagens` / Ficha resumida (Summary).
- No Console do Firebase -> Firestore -> `usuarios/{uid}` -> selecione `characters` ou `inventories`.
- Edite um documento (por exemplo, mude o `name` ou altere `quantity` em um item) e salve.
- Observe no app se a alteração aparece imediatamente (sem reiniciar o app).

Passos detalhados (recomendado):
1. Personagens - Lista em nuvem
  - Abra `Personagens (Nuvem)` (ou ative `Nuvem` em `Personagens`).
  - No Console do Firebase, altere o campo `name` de um documento em `usuarios/{uid}/characters`.
  - Verifique que a lista no app muda automaticamente para refletir o novo nome.

2. Inventário - Lista em nuvem
  - Abra `Inventário (Nuvem)`.
  - Edite o campo `quantity` ou `itemName` de um documento na coleção `inventories` no Console.
  - Confirme que a lista do app atualiza instantaneamente.

3. Ficha individual (document stream)
  - Abra a `Summary` de um documento específico (por ex., abra uma ficha via `Personagens (Nuvem)`).
  - No Console, altere um atributo (ex.: `attributes.STR`) no documento.
  - Verifique que a tela de `Summary` atualiza o valor exibido sem recarregar.

4. Pesquisa em tempo real
  - Abra `Pesquisar Personagens` e execute uma busca.
  - No Console, crie/edite um documento cujo nome corresponda ao filtro; confirme que os resultados da busca refletem a mudança imediatamente.

Referência técnica adicional
- Consulte `STREAMS_REPORT.md` (arquivo gerado) para ver os trechos exatos de código e as queries observadas: `app_rpg/STREAMS_REPORT.md`.

Observações
- Caso alguma das telas não atualize automaticamente, verifique se o documento tem os campos `createdAt`/`nameLower` quando aplicável e se o usuário autenticado é o dono do documento (regras de segurança podem bloquear leitura).
- Mensagens de erro e necessidade de índices podem aparecer no Console do Firebase; siga as instruções do console para criar índices quando necessário.

Relatório de resultado
- Para cada item acima, registre:
  - Ambiente (emulador/dispositivo, SO, versão Flutter)
  - Passos executados
  - Resultado esperado vs observado
  - Clipboard do log de erro (se houver)
  - Captura de tela (opcional)

Próximos passos que posso automatizar por você
- Gerar um script de importação/restauração JSON (Dart/Flutter CLI script) — opcional.
- Executar um checklist automatizado parcial (ex.: validar formatos de documentos no Firestore via script que usa Admin SDK) — requer credenciais de serviço.

---
11) Activity logs / 4ª coleção (RF003 requirement)

Objetivo: validar a existência de uma 4ª coleção por usuário (`activity_logs`) com pelo menos 5 campos e que gravações de atividades sejam registradas após operações de criação/atualização.

Passos:
- Realize a criação de um personagem (com usuário autenticado) usando `AddCharacterScreen`.
- No Console do Firebase, navegue até `usuarios/{uid}/activity_logs` e verifique que foi criado um documento com campos: `type`, `targetId`, `description`, `metadata`, `createdAt`.
- Realize uma edição em personagem ou inventário e confirme que uma nova entrada de `activity_logs` foi adicionada com `type` apropriado (`update_character` / `update_inventory_item`).

Resultado esperado: para cada operação de criação/atualização, há uma entrada correspondente em `activity_logs` contendo ≥5 campos e dados coerentes com a ação.

Arquivo criado: `TEST_MANUAL_QA.md` na raiz de `app_rpg`.
