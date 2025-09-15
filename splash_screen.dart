Future<void> _signInWithGoogle() async {
  setState(() { _isLoading = true; });
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return;

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    final User? user = userCredential.user;

    if (user != null) {
      await _addOrUpdateSession(user); // zapis sesji urządzenia
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        Navigator.of(context).pushReplacementNamed('/main_app_screen');
      } else {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': user.email,
          'name': user.displayName,
          'photoUrl': user.photoURL,
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        Navigator.of(context).pushReplacementNamed('/reg_name_screen');
      }
    }
  } catch (e) {
    print('Błąd logowania: $e');
  } finally {
    setState(() { _isLoading = false; });
  }
}
