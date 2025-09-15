Future<void> _loadUserName() async {
  try {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        final data = userDoc.data() as Map<String, dynamic>;
        setState(() {
          _userName = data['name'] ?? 'Użytkowniku';
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  } catch (e) {
    setState(() {
      _isLoading = false;
    });
  }
}

void _startCompletingProfile() {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const InterestQuestionScreen()),
  );
}
