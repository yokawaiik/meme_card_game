import 'dart:math';

int generateRandomSituation(int totalSituation) {
  int randomNumber = Random().nextInt(totalSituation) + 1;
  return randomNumber;
}
