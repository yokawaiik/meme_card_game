const _defaultAutomaticSituationSelection = true;
const _defaultTimeToDecision = 60;
const _defaultTimeToConfirmation = 60;
const _defaultTimeToBreak = 20;

class RoomConfiguration {
  late bool automaticSituationSelection;
  late int timeToDecision;
  late int timeToConfirmation;
  late int timeToBreak;

  RoomConfiguration({
    this.automaticSituationSelection = true,
    this.timeToDecision = 60,
    this.timeToConfirmation = 60,
    this.timeToBreak = 20,
  });

  RoomConfiguration.fromMap(Map<String, dynamic> data) {
    automaticSituationSelection = data["automatic_situation_selection"] ??
        _defaultAutomaticSituationSelection;
    timeToDecision =
        int.tryParse(data["time_to_decision"]) ?? _defaultTimeToDecision;
    timeToConfirmation = int.tryParse(data["time_to_confirmation"]) ??
        _defaultTimeToConfirmation;
    timeToBreak = int.tryParse(data["time_to_break"]) ?? _defaultTimeToBreak;
  }

  Map<String, dynamic> toMap() {
    return {
      "automatic_situation_selection": automaticSituationSelection,
      "time_to_decision": timeToDecision,
      "time_to_confirmation": timeToConfirmation,
      "time_to_break": timeToBreak,
    };
  }

  @override
  String toString() {
    return 'RoomConfiguration.instance: ${toMap().toString()}';
  }
}
