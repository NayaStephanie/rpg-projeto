# app_rpg

A new Flutter project.

## Configuração do Firebase Authentication e Firestore

Passos rápidos para testar autenticação (email/senha), recuperação de senha e salvar dados adicionais do usuário:

1. No Firebase Console do projeto `app-rpgo-6061a`, vá em Authentication > Sign-in method e ative o provedor "Email/Password".
2. No Firestore Database, crie um banco (modo produção ou teste). Os dados adicionais de usuários serão salvos na coleção `usuarios` com o document id igual ao uid do Firebase Auth.
3. Garanta regras mínimas (exemplo para testes):

```
rules_version = '2';
service cloud.firestore {
	match /databases/{database}/documents {
		match /usuarios/{userId} {
			allow read: if request.auth != null && request.auth.uid == userId;
			allow write: if request.auth != null && request.auth.uid == userId;
		}
	}
}
```

4. No projeto Flutter, `firebase_options.dart` já contém as credenciais. Rode o app (`flutter run`) e teste:
	 - Cadastro: preencha nome, email, telefone e senha. Os dados extras serão gravados na coleção `usuarios`.
	 - Login: entre com email e senha.
	 - Recuperar senha: envie um email de recuperação.

5. Logs/erros aparecem no console do Flutter e feedbacks são apresentados via SnackBars na UI.

Observações:
- Caso use Android/iOS, confirme o bundleId/packageName corresponda ao app registrado no Firebase.
- Para produção, revise regras do Firestore para maior segurança.

## Migração de dados

As instruções completas para migrar dados locais para o Firestore (backup, upload, publicação de regras e rollback) estão no arquivo separado `README_MIGRATION.md`.

Consulte `README_MIGRATION.md` na raiz do projeto para o passo-a-passo detalhado.
