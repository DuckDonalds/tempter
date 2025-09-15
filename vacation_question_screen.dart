void _onPreferenceSelected(VacationPreference preference) {
  setState(() {
    if (_selectedPreferences.contains(preference)) {
      _selectedPreferences.remove(preference);
    } else {
      _selectedPreferences.add(preference);
    }
  });
}

Future<void> _onContinue() async {
  if (_selectedPreferences.isNotEmpty) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      List<String> preferencesToSave = _selectedPreferences
          .map((p) => p.toString().split('.').last)
          .toList();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({'vacationPreferences': preferencesToSave}, SetOptions(merge: true));
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegAdditionalInfoScreen()),
    );
  }
}
