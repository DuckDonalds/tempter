Future<String> _getCurrentDeviceId() async {
  if (kIsWeb) {
    WebBrowserInfo webInfo = await deviceInfoPlugin.webBrowserInfo;
    return webInfo.userAgent ?? 'web';
  } else if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
    return androidInfo.id;
  }
  // Pozostałe platformy...
}


await _firestore.collection('users').doc(user.uid).collection('sessions').doc(_currentDeviceId).set({
  'deviceId': _currentDeviceId,
  'deviceInfo': deviceInfo,
  'lastSignInTime': FieldValue.serverTimestamp(),
  'status': 'active',
  'location': location,
}, SetOptions(merge: true));


await _firestore.collection('users').doc(user.uid).collection('sessions').doc(deviceId).update({
  'status': 'signed_out',
  'signOutTime': FieldValue.serverTimestamp(),
});
