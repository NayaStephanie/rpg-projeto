# STREAMS_REPORT.md

Relatório das streams usadas pelo app (uso de StreamBuilder / snapshots).

Objetivo: mostrar onde o app observa o Firestore em tempo real, quais coleções/queries são usadas e trechos de código relevantes para validar o RF005 (Recuperação de Dados).

---

## 1) `lib/screens/character/firestore_characters_list_screen.dart`

Query observada (stream):

```dart
final stream = FirebaseFirestore.instance
    .collection('usuarios')
    .doc(user.uid)
    .collection('characters')
    .orderBy('createdAt', descending: true)
    .snapshots();
```

Uso: `StreamBuilder<QuerySnapshot>` que renderiza um `ListView.builder` com os documentos `characters`. Permite editar/excluir e abrir `CharacterSheet(firestoreDocId: doc.id)`.

Validação rápida: abra a tela "Personagens (Nuvem)" e edite um documento no Console do Firebase; a lista deve atualizar automaticamente.

---

## 2) `lib/screens/character/firestore_inventories_list_screen.dart`

Query observada (stream):

```dart
final stream = FirebaseFirestore.instance
    .collection('usuarios')
    .doc(user.uid)
    .collection('inventories')
    .orderBy('createdAt', descending: true)
    .snapshots();
```

Uso: `StreamBuilder<QuerySnapshot>` que mostra `ListView` de itens do inventário, com edição (`EditInventoryFirestoreScreen`) e exclusão.

Validação rápida: abra a tela "Inventário (Nuvem)" e altere um documento no Console; a lista deve atualizar em tempo real.

---

## 3) `lib/screens/characters/characters_list_screen.dart`

- A tela principal agora alterna entre view local e cloud via toggle `Nuvem`.
- Quando em modo nuvem, ela chama `_buildCloudList()` internamente, cuja query é idêntica à usada em `firestore_characters_list_screen.dart`:

```dart
FirebaseFirestore.instance
    .collection('usuarios')
    .doc(FirebaseAuth.instance.currentUser?.uid)
    .collection('characters')
    .orderBy('createdAt', descending: true)
    .snapshots()
```

Uso: `StreamBuilder<QuerySnapshot>` dentro de `_buildCloudList()` — exibe lista em tempo real; quando `_useCloud` está falso, a tela mostra a lista local (`_buildLocalList()`).

Validação rápida: ative o toggle "Nuvem" e confirme atualizações feitas no Console do Firebase.

---

## 4) `lib/screens/ficha/summary_firestore_screen.dart`

Query observada (stream de documento):

```dart
final docRef = FirebaseFirestore.instance
    .collection('usuarios')
    .doc(user.uid)
    .collection('characters')
    .doc(docId);

// ...

body: StreamBuilder<DocumentSnapshot>(
  stream: docRef.snapshots(),
  builder: (context, snapshot) { ... }
)
```

Uso: monitoramento em tempo real de um documento `characters/{docId}` para mostrar a ficha resumida. Útil para ver mudanças pontuais (por ex. alterações de atributos) sem recarregar.

Validação rápida: edite o documento específico no Console do Firebase e observe a atualização na tela de ficha (Summary).

---

## 5) `lib/screens/character/firestore_search_screen.dart`

Query observada (stream via helper `_baseQuery()`):

```dart
// dentro de _baseQuery():
final coll = db.collection('usuarios').doc(user!.uid).collection('characters');
// retorna coll.orderBy('nameLower' or 'createdAt') conforme sort

// no StreamBuilder:
stream: _baseQuery().snapshots(),
```

Uso: `StreamBuilder<QuerySnapshot>` com filtragem client-side (usa `nameLower` quando disponível). Atualizações no Firestore aparecem automaticamente nos resultados da busca.

Validação rápida: adicionar/editar um personagem no Console (ou via app) e usar a busca para confirmar que o resultado reflete a mudança.

---

## Notas gerais e recomendações

- Coleções observadas (duas coleções distintas exigidas pelo RF005):
  - `usuarios/{uid}/characters`
  - `usuarios/{uid}/inventories`

- Ordenação: a maioria das queries usa `orderBy('createdAt', ...)` ou `orderBy('nameLower', ...)`. Garanta que os documentos tenham esses campos preenchidos (MigrationScreen e rotinas de gravação já cuidam disso quando possível).

- Tipos de snapshot: ambos `QuerySnapshot` (listas) e `DocumentSnapshot` (documento único) são usados, cobrindo cenários de listagem e observação pontual.

- Filtragem/Busca: atualmente a busca faz filtragem client-side usando `nameLower` quando disponível. Para coleções grandes, considere queries server-side (startAt/endAt) para reduzir leituras e custos.

---

## Validação sugerida (passo a passo curto)

1. Abra o app com um usuário autenticado.
2. Abra a tela `Personagens (Nuvem)` ou ative `Nuvem` na tela de Personagens.
3. No Console do Firebase, navegue para `Firestore Database > Collection > usuarios > {uid} > characters`.
4. Edite o campo `name` de um documento e salve.
5. Observe a alteração aparecer no app instantaneamente (sem reiniciar).

Repita para `inventories` e / ou abra a `Summary` de um documento específico e edite um campo para ver atualização em tempo real.

---

## Arquivos/locais para auditoria rápida

- `lib/screens/character/firestore_characters_list_screen.dart`
- `lib/screens/character/firestore_inventories_list_screen.dart`
- `lib/screens/characters/characters_list_screen.dart` (toggle + `_buildCloudList()`)
- `lib/screens/ficha/summary_firestore_screen.dart` (document stream)
- `lib/screens/character/firestore_search_screen.dart` (search stream)

---

Arquivo gerado pelo assistente em: `app_rpg/STREAMS_REPORT.md`.

Se quiser, posso:
- adicionar este relatório ao `README.md` ou `TEST_MANUAL_QA.md` (link/trecho),
- gerar um pequeno script de verificação (Admin SDK) que lista documentos e confirma presença de `createdAt`/`nameLower` (requer credenciais de serviço),
- ou criar testes de integração para automatizar a verificação (tempo/complexidade maiores).

Indique qual ação prefere a seguir.