Future<void> _onContinue() async {
  if (_imageFile == null) return;

  setState(() { _isLoading = true; });

  String base64Image = await _fileToBase64(_imageFile!);
  const apiKey = "API_KEY";

  final url = Uri.parse(
    'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-preview-05-20:generateContent?key=$apiKey'
  );

  final body = jsonEncode({
    "contents": [
      {
        "role": "user",
        "parts": [
          {"text": "Extract first name and date of birth from this document."},
          {"inlineData": {"mimeType": "image/jpeg", "data": base64Image}}
        ]
      }
    ],
    "generationConfig": {"responseMimeType": "application/json"}
  });

  final response = await http.post(url, headers: {'Content-Type': 'application/json'}, body: body);

  if (response.statusCode == 200) {
    final result = jsonDecode(response.body);
    // Parsowanie JSON i walidacja imienia/daty
  }

  setState(() { _isLoading = false; });
}
