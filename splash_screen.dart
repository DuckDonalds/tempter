# tempter
Date App
Przykładowe storny, zdjecia oraz kody z aplkacji rankowej Tempter date APP.
Pokazane na dole kod pokazuje łaczenie z bazą danych podczas logowania. 

 Future<void> _addOrUpdateSession(User user) async {
    String currentDeviceId = 'unknown';
    Map<String, dynamic> deviceInfo = {};

    try {
      if (kIsWeb) {
        WebBrowserInfo webInfo = await _deviceInfoPlugin.webBrowserInfo;
        currentDeviceId = webInfo.userAgent ?? 'web';
        deviceInfo = {
          'userAgent': webInfo.userAgent,
          'vendor': webInfo.vendor,
          'platform': webInfo.platform,
          'name': 'Przeglądarka internetowa',
        };
      } else if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await _deviceInfoPlugin.androidInfo;
        currentDeviceId = androidInfo.id;
        deviceInfo = {
          'model': androidInfo.model,
          'version': androidInfo.version.release,
          'brand': androidInfo.brand,
          'name': '${androidInfo.brand} ${androidInfo.model}',
        };
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await _deviceInfoPlugin.iosInfo;
        currentDeviceId = iosInfo.identifierForVendor ?? 'unknown_ios';
        deviceInfo = {
          'model': iosInfo.model,
          'systemName': iosInfo.systemName,
          'systemVersion': iosInfo.systemVersion,
          'name': '${iosInfo.systemName} ${iosInfo.model}',
        };
      } else if (Platform.isWindows) {
        WindowsDeviceInfo windowsInfo = await _deviceInfoPlugin.windowsInfo;
        currentDeviceId = windowsInfo.deviceId;
        deviceInfo = {
          'computerName': windowsInfo.computerName,
          'majorVersion': windowsInfo.majorVersion,
          'name': 'Windows PC',
        };
      } else if (Platform.isLinux) {
        LinuxDeviceInfo linuxInfo = await _deviceInfoPlugin.linuxInfo;
        currentDeviceId = linuxInfo.machineId ?? 'unknown_linux';
        deviceInfo = {
          'name': linuxInfo.prettyName,
        };
      } else if (Platform.isMacOS) {
        MacOsDeviceInfo macOsInfo = await _deviceInfoPlugin.macOsInfo;
        currentDeviceId = macOsInfo.systemGUID ?? 'unknown_macos';
        deviceInfo = {
          'model': macOsInfo.model,
          'kernelVersion': macOsInfo.kernelVersion,
          'name': 'Mac OS',
        };
      }
    } catch (e) {
      print('Błąd pobierania ID urządzenia: $e');
    }

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).collection('sessions').doc(currentDeviceId).set({
        'deviceId': currentDeviceId,
        'deviceInfo': deviceInfo,
        'lastSignInTime': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Błąd podczas zapisywania sesji: $e');
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() { _isLoading = true; });
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() { _isLoading = false; });
        return;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        await _addOrUpdateSession(user);

        final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          if (mounted) {
            Navigator.of(context).pushReplacementNamed('/main_app_screen');
          }
        } else {
          if (mounted) {
            await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
              'email': user.email,
              'name': user.displayName,
              'photoUrl': user.photoURL,
              'createdAt': FieldValue.serverTimestamp(),
            }, SetOptions(merge: true));
            Navigator.of(context).pushReplacementNamed('/reg_name_screen');
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      print('Błąd logowania Firebase z Google: ${e.code}');
      String errorMessage = 'Wystąpił błąd podczas logowania: ${e.message}';
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    } catch (e) {
      print('Ogólny błąd logowania Google: $e');
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Wystąpił nieoczekiwany błąd: ${e.toString()}')));
      }
    } finally {
      if(mounted) {
        setState(() { _isLoading = false; });
      }
    }
  }
