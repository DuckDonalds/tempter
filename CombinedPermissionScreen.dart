Future<void> _requestAllPermissions() async {
  var locationStatus = await Permission.location.request();
  if (!locationStatus.isGranted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Uprawnienia do lokalizacji są wymagane.')),
    );
    return;
  }

  var notificationStatus = await Permission.notification.request();
  if (!notificationStatus.isGranted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Nie udzielono uprawnień do powiadomień.')),
    );
  }

  if (locationStatus.isGranted) {
    Navigator.pushReplacementNamed(context, '/id_verification_screen');
  }
}
