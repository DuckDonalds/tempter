Future<void> _updateSettingsInFirestore(Map<String, dynamic> data) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;
  await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
    data,
    SetOptions(merge: true),
  );
}
