String? baseFieldCheck(
  String fieldName,
  String? value, {
  bool isRequired = false,
  String? emptyLengthMessage,
  int minLength = 10,
  String? minLengthMessage,
  int maxLength = 100,
  String? maxLengthMessage,
}) {
  minLengthMessage ??= "This field must be more then $minLength.";
  maxLengthMessage ??= "This field must be less then $maxLength.";
  emptyLengthMessage ??= "This field is required.";

  if (isRequired) {
    if (value == null || value.isEmpty) {
      return emptyLengthMessage;
    } else if (value.length < minLength) {
      return minLengthMessage;
    } else if (value.length > maxLength) {
      return maxLengthMessage;
    }
  } else {
    if (value != null) {
      if (value.length > maxLength) {
        return maxLengthMessage;
      } else if (value.isNotEmpty && value.length < minLength) {
        return minLengthMessage;
      }
    }
  }

  return null;
}

String? onlyNumbersAndLettersCheck(
  String? value,
  String fieldName, {
  String? emptyLengthMessage,
  bool isRequired = false,
  bool checkValue = false,
  int minValue = 1,
  int maxValue = 10,
  String? checkValueMessage,
  int minLength = 10,
  String? minLengthMessage,
  int maxLength = 100,
  String? maxLengthMessage,
  bool validateByRegExp = true,
  String? message,
}) {
  var baseCheck = baseFieldCheck(
    fieldName,
    value,
    minLength: minLength,
    emptyLengthMessage: emptyLengthMessage,
    maxLength: maxLength,
    maxLengthMessage: maxLengthMessage,
    isRequired: isRequired,
  );
  if (baseCheck == null) {
    message ??= "This field must contain only letters and numbers.";

    if (validateByRegExp) {
      final isValid = RegExp(r"[\w.-]{0,19}[0-9a-zA-Z]$").hasMatch(value!);
      if (!isValid) return message;
    }
  }
  return baseCheck;
}

String? onlyNumbers(
  String fieldName,
  int? value, {
  String? emptyValueMessage,
  bool isRequired = false,
  int minValue = 1,
  int maxValue = 10,
  String? checkValueMessage,
  String? minValueMessage,
  String? maxValueMessage,
  String? message,
}) {
  minValueMessage ??= "This field must be more then $minValue.";
  maxValueMessage ??= "This field must be less then $maxValue.";
  emptyValueMessage ??= "This field is required.";

  if (isRequired) {
    if (value == null || value == 0) {
      return emptyValueMessage;
    } else if (value < minValue) {
      return minValueMessage;
    } else if (value > maxValue) {
      return maxValueMessage;
    }
  } else {
    if (value != null) {
      if (value < minValue) {
        return minValueMessage;
      } else if (value > maxValue) {
        return maxValueMessage;
      }
    }
  }
  return null;
}
