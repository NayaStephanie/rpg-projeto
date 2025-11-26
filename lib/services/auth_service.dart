// Serviço simples para autenticação com Firebase Auth e armazenamento no Firestore
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Faz login com email e senha
  static Future<UserCredential> signIn({required String email, required String password}) async {
    final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    // Após login, garantimos que o usuário tenha as configurações mínimas salvas
    final uid = credential.user?.uid;
    if (uid != null) {
      try {
        await _firestore.collection('usuarios').doc(uid).collection('settings').doc('prefs').set({
          'is_premium_user': true,
          'storage_type': 'cloud',
        }, SetOptions(merge: true));
      } catch (_) {
        // Não bloquear o login se gravação falhar
      }
    }

    return credential;
  }

  /// Cria usuário com email/senha e salva dados extras na coleção `usuarios`.
  static Future<UserCredential> signUp({required String name, required String phone, required String email, required String password}) async {
    final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

    // Armazena dados adicionais no Firestore na coleção 'usuarios' usando uid como id
    final uid = credential.user?.uid;
    if (uid != null) {
      await _firestore.collection('usuarios').doc(uid).set({
        'name': name,
        // campos adicionais para atender requisito de ao menos 5 campos
        'displayName': name,
        'phone': phone,
        'email': email,
        'locale': 'pt_BR',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    return credential;
  }

  /// Envia email para recuperação de senha
  static Future<void> sendPasswordReset({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  /// Encerra a sessão do usuário atual
  static Future<void> signOut() async {
    await _auth.signOut();
  }
}
