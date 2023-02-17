import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meme_card_game/src/common_widgets/default_text_field.dart';
import 'package:meme_card_game/src/features/game/presentation/cubit/game_cubit.dart';

import '../../../../routing/routes_constants.dart' as routes_constants;
import '../../../../utils/validators.dart' as validators;

class GameCreateScreen extends StatefulWidget {
  const GameCreateScreen({super.key});

  @override
  State<GameCreateScreen> createState() => _GameCreateScreenState();
}

class _GameCreateScreenState extends State<GameCreateScreen> {
  late final TextEditingController titleRoomTextController;
  late final GlobalKey<FormState> _formKey;

  late bool automaticSituationSelection;

  @override
  void initState() {
    titleRoomTextController = TextEditingController();
    automaticSituationSelection = true;
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  controller: titleRoomTextController,
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
                  subtitle:
                      const Text("It's choosing randomly from public database"),
                  value: automaticSituationSelection,
                  onChanged: (v) {
                    automaticSituationSelection = !automaticSituationSelection;
                  },
                  enabled: true, // todo: remove it after adding a functionality
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FilledButton.tonalIcon(
                      onPressed: () => _createRoom(context),
                      icon: const Icon(Icons.people),
                      label: const Text(
                        "Create room",
                      ),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(
                          100,
                          46,
                        ),
                      ),
                    ),
                  ],
                ),
                // todo: add time for choosing a situation

                // // todo: delete it
                // ElevatedButton(
                //     onPressed: () {
                //       final gameCubit = context.read<GameCubit>();
                //       gameCubit.testSendData();
                //     },
                //     child: Text("Send data"))
              ],
            ),
          ),
        ),
      ),
    );
  }

  _createRoom(BuildContext context) async {
    try {
      // todo: validate fields
      _formKey.currentState!.save();
      final validationResult = _formKey.currentState!.validate();

      print('validationResult: $validationResult');

      if (!validationResult) return;

      final gameCubit = context.read<GameCubit>();

      await gameCubit.createGame(titleRoomTextController.text);
      context.pushNamed(routes_constants.gameLobby);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong"),
        ),
      );
    }
  }
}
