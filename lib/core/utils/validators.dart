class Validators {
  Validators._();
  
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }
  
  static bool isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^[6-9]\d{9}$');
    return phoneRegex.hasMatch(phone.replaceAll(RegExp(r'[^\d]'), ''));
  }
  
  static bool isValidPincode(String pincode) {
    final pincodeRegex = RegExp(r'^[1-9][0-9]{5}$');
    return pincodeRegex.hasMatch(pincode);
  }
  
  static bool isValidAadhaar(String aadhaar) {
    final aadhaarRegex = RegExp(r'^[2-9]{1}[0-9]{11}$');
    final cleanAadhaar = aadhaar.replaceAll(RegExp(r'[^\d]'), '');
    return aadhaarRegex.hasMatch(cleanAadhaar);
  }
  
  static bool isValidName(String name) {
    return name.trim().length >= 2 && name.trim().length <= 100;
  }
  
  static bool isValidArea(double? area) {
    return area != null && area > 0 && area <= 100000;
  }
  
  static bool isNotEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }
  
  static bool isPositiveNumber(num? value) {
    return value != null && value > 0;
  }
  
  static bool isInRange(num value, num min, num max) {
    return value >= min && value <= max;
  }
  
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
  
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!isValidEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }
  
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    if (!isValidPhone(value)) {
      return 'Please enter a valid 10-digit phone number';
    }
    return null;
  }
  
  static String? validatePincode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Pincode is required';
    }
    if (!isValidPincode(value)) {
      return 'Please enter a valid 6-digit pincode';
    }
    return null;
  }
}
