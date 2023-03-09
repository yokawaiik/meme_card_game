import 'dart:math';

int generateRandomNumber(int maxNumber) {
  int randomNumber = Random().nextInt(maxNumber);
  return randomNumber;
}
