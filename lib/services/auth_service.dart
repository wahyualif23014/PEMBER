import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "../../models/user_model.dart"; // pastikan path ini sesuai

ValueNotifier<AuthService> authService = ValueNotifier(AuthService());

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  // ✅ SIGN UP - now using UserModel
  Future<UserCredential> signUpWithModel(UserModel userModel) async {
    final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
      email: userModel.email,
      password: userModel.password,
    );

    final uid = userCredential.user!.uid;

    // Simpan ke Firestore
    await FirebaseFirestore.instance.collection("users").doc(uid).set({
      ...userModel.toJson(),
      "id": uid,
    });

    // Set displayName di Firebase Auth
    await userCredential.user!.updateDisplayName(userModel.username);

    return userCredential;
  }

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  Future<void> resetPassword({required String email}) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    await currentUser!.reauthenticateWithCredential(credential);
    await currentUser!.delete();
    await firebaseAuth.signOut();
  }

  Future<void> resetPasswordFromCurrentPassword({
    required String currentPassword,
    required String newPassword,
    required String email,
  }) async {
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: currentPassword,
    );
    await currentUser!.reauthenticateWithCredential(credential);
    await currentUser!.updatePassword(newPassword);
  }

  Future<void> updateProfile({
    required String username,
    required String email,
    String? profileImageBase64,
  }) async {
    final user = currentUser;
    if (user == null) return;

    await user.updateDisplayName(username);

    if (user.email != email) {
      await user.verifyBeforeUpdateEmail(email);
    }

    final updateData = {"username": username, "email": email};

    if (profileImageBase64 != null) {
      updateData["profileImageBase64"] = profileImageBase64;
    }

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .update(updateData);
  }

  
}
