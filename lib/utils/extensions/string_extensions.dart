extension StringExtensions on String {
  /// Capitalize first letter of the word
  String get inFirstLetterCaps => length > 0 ? '${this[0].toUpperCase()}${substring(1)}' : '';

  bool get containsDigits {
    return RegExp(r'\d').hasMatch(this);
  }
}