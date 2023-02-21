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

  /// [_timeToDecisionTextController.value] in seconds
  late final TextEditingController _timeToDecisionTextController;

  /// [_timeToConfirmationTextController.value] in seconds
  late final TextEditingController _timeToConfirmationTextController;

  /// [_timeToBreakTextController.value] in seconds
  late final TextEditingController _timeToBreakTextController;

  @override
  void initState() {
    _titleRoomTextController = TextEditingController();
    // ? info: options for room
    _automaticSituationSelection = true;
    _timeToDecisionTextController = TextEditingController(text: "60");
    _timeToConfirmationTextController = TextEditingController(text: "60");
    _timeToBreakTextController = TextEditingController(text: "20");
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // todo: take out to the router
    return BlocListener<GameCubit, GameState>(
      listenWhen: (previous, current) {
        if (previous is CreatedGameState && current is JoinedRoomState) {
          return true;
        }
        return false;
      },
      listener: (context, state) {
        context.pushReplacementNamed(routes_constants.gameLobby);
      },
      child: WillPopScope(
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
                    DefaultTextField(
                      labelText: "Time to desicion (seconds)",
                      controller: _timeToDecisionTextController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (value) {
                        if (value == "") {
                          _timeToDecisionTextController.text += "10";
                        }
                      },
                      validator: (value) => validators.onlyNumbers(
                        "Time to desicion",
                        int.parse("${value ?? 0}"),
                        minValue: 10,
                        maxValue: 180,
                        isRequired: true,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    DefaultTextField(
                      labelText: "Time to confirmation (seconds)",
                      controller: _timeToConfirmationTextController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (value) {
                        if (value == "") {
                          _timeToConfirmationTextController.text += "10";
                        }
                      },
                      validator: (value) => validators.onlyNumbers(
                        "Time to confirmation",
                        int.parse("${value ?? 0}"),
                        minValue: 10,
                        maxValue: 180,
                        isRequired: true,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    DefaultTextField(
                      labelText: "Time to break (seconds)",
                      controller: _timeToBreakTextController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (value) {
                        if (value == "") {
                          _timeToBreakTextController.text += "10";
                        }
                      },
                      validator: (value) => validators.onlyNumbers(
                        "Time to break",
                        int.parse("${value ?? 0}"),
                        minValue: 10,
                        maxValue: 180,
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
                            final isLoadingGameState =
                                state is LoadingGameState;
                            final isCreatedGameState =
                                state is CreatedGameState;

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
        timeToDecision:
            int.tryParse('${_timeToDecisionTextController.value}') ?? 60,
        timeToConfirmation:
            int.tryParse('${_timeToConfirmationTextController.value}') ?? 60,
        timeToBreak: int.tryParse('${_timeToBreakTextController.value}') ?? 20,
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
