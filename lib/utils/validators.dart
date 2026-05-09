import 'imports.dart';

/// Centralized validation logic for form fields across the application.
class AppValidators {
  final AppLocalizations _appStrings;

  AppValidators(this._appStrings);

  /// Validates that a field is not null or empty.
  String? requiredField(String? value) {
    if (value == null || value.isEmpty) {
      return _appStrings.msgRequired;
    }
    return null;
  }

  /// Validates that a string contains a valid numerical value.
  String? numberField(String? value, {bool isRequired = true}) {
    if (isRequired) {
      final error = requiredField(value);
      if (error != null) return error;
    }

    if (value != null && double.tryParse(value) == null) {
      return _appStrings.msgValidNumber;
    }

    return null;
  }

  /// Specialized validation for registration plates.
  ///
  /// Checks for existence in [existingPlates] to prevent duplicates,
  /// unless [isEditing] is true and the plate matches [initialPlate].
  String? registrationPlate(
    String? value, {
    required Map<String, bool> existingPlates,
    bool isEditing = false,
    String? initialPlate,
  }) {
    final requiredError = requiredField(value);
    if (requiredError != null) return requiredError;

    if (existingPlates.containsKey(value!) &&
        (!isEditing || initialPlate != value)) {
      return _appStrings.msgPlateExist;
    }
    return null;
  }

  /// Validates the format of a phone number.
  String? validatePhoneNumber(String? value) {
    final error = requiredField(value);
    if (error != null) return error;

    // Simple regex for phone numbers including international plus signs.
    final RegExp phoneRegex = RegExp(r'^[\+]?[0-9\-\(\)]*$');

    if (phoneRegex.hasMatch(value!)) {
      return null;
    }
    return _appStrings.msgValidPhoneNumber;
  }

  /// Validates fields representing monetary amounts.
  ///
  /// Ensures the value is a positive number.
  String? validateMoneyField(String? value, {bool isRequired = true}) {
    if (isRequired) {
      final error = requiredField(value);
      if (error != null) return error;
    }
    if (value != null && double.tryParse(value) == null) {
      return _appStrings.msgValidNumber;
    }
    if (value != null && double.parse(value) < 0) {
      return _appStrings.msgOnlyPositive;
    }
    return null;
  }
}
