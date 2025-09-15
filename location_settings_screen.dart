Future<void> _searchAndSetPassportLocation(String addressQuery) async {
  List<Location> locations = await locationFromAddress(addressQuery, localeIdentifier: "pl_PL");
  List<Placemark> placemarks = await placemarkFromCoordinates(locations.first.latitude, locations.first.longitude, localeIdentifier: "pl_PL");
  _passportLocation = GeoPoint(locations.first.latitude, locations.first.longitude);
  _passportAddress = _formatPlacemark(placemarks.first);
}


Future<void> _getCurrentGeolocatedLocationAndAddress({bool forceUpdateRealLocation = false}) async {
  ...
  Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
  List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude, localeIdentifier: "pl_PL");
  _realGeoAddress = _formatPlacemark(placemarks.first);
  ...
}


Future<void> _savePreferences() async {
  Map<String, dynamic> dataToUpdate = {...};
  await FirebaseFirestore.instance.collection('users').doc(user.uid).set(dataToUpdate, SetOptions(merge: true));
}
