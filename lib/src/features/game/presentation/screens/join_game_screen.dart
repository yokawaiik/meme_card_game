import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meme_card_game/src/features/game/presentation/cubit/game_cubit.dart';

import '../../../../common_widgets/default_text_field.dart';

import '../../../../routing/routes_constants.dart' as routes_constants;

import '../../../../utils/validators.dart' as validators;

class JoinGameScreen extends StatefulWidget {
  const JoinGameScreen({super.key});

  @override
  State<JoinGameScreen> createState() => _JoinGameScreenState();
}

class _JoinGameScreenState extends State<JoinGameScreen> {
  late final TextEditingController _titleRoomTextController;
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    _titleRoomTextController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Join room"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DefaultTextField(
                labelText: "Room's id",
                controller: _titleRoomTextController,
                validator: (value) => validators.baseFieldCheck(
                  "Room's id",
                  value,
                  isRequired: true,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FilledButton.tonalIcon(
                    onPressed: () => _joinRoom(context),
                    icon: const Icon(Icons.people),
                    label: const Text(
                      "Join room",
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
            ],
          ),
        ),
      ),
    );
  }

  _joinRoom(BuildContext context) async {
    try {
      _formKey.currentState!.save();
      final validationResult = _formKey.currentState!.validate();

      if (!validationResult) return;

      final gameCubit = context.read<GameCubit>();

      await gameCubit.joinRoom(_titleRoomTextController.text);
      // context.pushNamed(routes_constants.gameLobby);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Something went wrong'),
        ),
      );
    }
  }
}
