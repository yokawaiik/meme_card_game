import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meme_card_game/src/common_widgets/default_text_field.dart';
import 'package:meme_card_game/src/features/game/domain/models/room_configuration.dart';
import 'package:meme_card_game/src/features/game/presentation/cubit/game_cubit.dart';

import '../../../../routing/routes_constants.dart' as routes_constants;
import '../../../../utils/validators.dart' as validators;

class GameCreateScreen extends StatefulWidget {
  const GameCreateScreen({super.key});

  @override
  State<GameCreateScreen> createState() => _GameCreateScreenState();
}

class _GameCreateScreenState extends State<GameCreateScreen> {
  late final TextEditingController _titleRoomTextController;
  late final GlobalKey<FormState> _formKey;

  late bool _automaticSituationSelection;

  /// [_timeToConfirmationTextController.value] in seconds
  late final TextEditingController _timeToConfirmationTextController;

  /// [_timeForChooseSituationTextController.value] in seconds
  late final TextEditingController _timeForChooseSituationTextController;

  /// [_timeForVoteForCardTextController.value] in seconds
  late final TextEditingController _timeForVoteForCardTextController;

  /// [_roundsCountTextController.value] in seconds
  late final TextEditingController _roundsCountTextController;

  /// [_playersCountTextController.value] in seconds
  late final TextEditingController _playersCountTextController;

  @override
  void initState() {
    _titleRoomTextController = TextEditingController();
    // ? info: options for room
    _automaticSituationSelection = true;
    _timeForChooseSituationTextController = TextEditingController(text: "30");
    _timeToConfirmationTextController = TextEditingController(text: "60");
    _timeForVoteForCardTextController = TextEditingController(text: "20");
    _roundsCountTextController = TextEditingController(text: "7");
    _playersCountTextController = TextEditingController(text: "7");
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // todo: take out to the router
    return WillPopScope(
      onWillPop: () => _disposeRoom(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Create new game"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  DefaultTextField(
                    labelText: "Title room",
                    controller: _titleRoomTextController,
                    validator: (value) => validators.baseFieldCheck(
                      "Title room",
                      value,
                      isRequired: true,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // todo: add time for answer
                  CheckboxListTile(
                    title: const Text("Automatic situation selection"),
                    subtitle: const Text(
                        "It's choosing randomly from public database"),
                    value: _automaticSituationSelection,
                    onChanged: _toggleAutomaticSituationSelection,
                    enabled:
                        false, // todo: remove it after adding a functionality
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  // DefaultTextField(
                  //   labelText: "Time to confirmation (seconds)",
                  //   controller: _timeToConfirmationTextController,
                  //   keyboardType: TextInputType.number,
                  //   inputFormatters: [
                  //     FilteringTextInputFormatter.digitsOnly,
                  //   ],
                  //   onChanged: (value) {
                  //     if (value == "") {
                  //       _timeToConfirmationTextController.text += "10";
                  //     }
                  //   },
                  //   readOnly: true,
                  //   validator: (value) => validators.onlyNumbers(
                  //     "Time to confirmation",
                  //     int.parse("${value ?? 0}"),
                  //     minValue: 10,
                  //     maxValue: 180,
                  //     isRequired: true,
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // DefaultTextField(
                  //   labelText: "Time for choose situation (seconds)",
                  //   controller: _timeForChooseSituationTextController,
                  //   keyboardType: TextInputType.number,
                  //   inputFormatters: [
                  //     FilteringTextInputFormatter.digitsOnly,
                  //   ],
                  //   onChanged: (value) {
                  //     if (value == "") {
                  //       _timeForChooseSituationTextController.text += "10";
                  //     }
                  //   },
                  //   readOnly: true,
                  //   validator: (value) => validators.onlyNumbers(
                  //     "Time for choose situation",
                  //     int.parse("${value ?? 0}"),
                  //     minValue: 10,
                  //     maxValue: 180,
                  //     isRequired: true,
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // DefaultTextField(
                  //   labelText: "Time for vote for card (seconds)",
                  //   controller: _timeForVoteForCardTextController,
                  //   keyboardType: TextInputType.number,
                  //   inputFormatters: [
                  //     FilteringTextInputFormatter.digitsOnly,
                  //   ],
                  //   onChanged: (value) {
                  //     if (value == "") {
                  //       _timeForVoteForCardTextController.text += "10";
                  //     }
                  //   },
                  //   readOnly: true,
                  //   validator: (value) => validators.onlyNumbers(
                  //     "Time for vote for card",
                  //     int.parse("${value ?? 0}"),
                  //     minValue: 10,
                  //     maxValue: 180,
                  //     isRequired: true,
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  const SizedBox(
                    height: 10,
                  ),
                  DefaultTextField(
                    labelText: "Players count",
                    controller: _playersCountTextController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (value) {
                      if (value == "") {
                        _playersCountTextController.text += "5";
                      }
                    },
                    readOnly: true,
                    validator: (value) => validators.onlyNumbers(
                      "Players count",
                      int.parse("${value ?? 0}"),
                      minValue: 2,
                      maxValue: 10,
                      isRequired: true,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DefaultTextField(
                    labelText: "Rounds count",
                    controller: _roundsCountTextController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (value) {
                      if (value == "") {
                        _roundsCountTextController.text += "7";
                      }
                    },
                    readOnly: true,
                    validator: (value) => validators.onlyNumbers(
                      "Rounds count",
                      int.parse("${value ?? 0}"),
                      minValue: 2,
                      maxValue: 10,
                      isRequired: true,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      BlocBuilder<GameCubit, GameState>(
                        buildWhen: (previous, current) {
                          if (current is LoadingGameState ||
                              current is CreatedGameState) {
                            return true;
                          }
                          return false;
                        },
                        builder: (context, state) {
                          final isLoadingGameState = state is LoadingGameState;
                          final isCreatedGameState = state is CreatedGameState;

                          return Stack(
                            children: [
                              if (isLoadingGameState)
                                const Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                ),
                              FilledButton.tonalIcon(
                                onPressed:
                                    (isLoadingGameState || isCreatedGameState)
                                        ? null
                                        : () => _createRoom(context),
                                icon: const Icon(Icons.people),
                                label: Text(
                                  isCreatedGameState
                                      ? "Wait for join"
                                      : "Create room",
                                ),
                                style: FilledButton.styleFrom(
                                  minimumSize: const Size(
                                    100,
                                    46,
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _toggleAutomaticSituationSelection(v) {
    setState(() {
      _automaticSituationSelection = !_automaticSituationSelection;
    });
  }

  _createRoom(BuildContext context) async {
    try {
      _formKey.currentState!.save();
      final validationResult = _formKey.currentState!.validate();

      if (!validationResult) {
        return;
      }

      final roomConfiguration = RoomConfiguration(
        automaticSituationSelection: _automaticSituationSelection,
        timeForConfirmation:
            int.tryParse('${_timeToConfirmationTextController.value}') ?? 60,
        timeForChooseSituation:
            int.tryParse('${_timeForChooseSituationTextController.value}') ??
                20,
        timeForVoteForCard:
            int.tryParse('${_timeForVoteForCardTextController.value}') ?? 20,
        roundsCount: int.tryParse('${_roundsCountTextController.value}') ?? 7,
        playersCount: int.tryParse('${_playersCountTextController.value}') ?? 7,
      );

      final gameCubit = context.read<GameCubit>();
      await gameCubit.createGame(
        _titleRoomTextController.text,
        roomConfiguration,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong"),
        ),
      );
    }
  }

  Future<bool> _disposeRoom(BuildContext context) async {
    final gameCubit = context.read<GameCubit>();

    await gameCubit.closeRoom();
    return true;
  }
}
