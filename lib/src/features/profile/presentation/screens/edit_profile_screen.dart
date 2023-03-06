import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meme_card_game/src/features/auth/presentation/cubit/authentication_cubit.dart';

import '../../../../common_widgets/full_image_avatar.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  Uint8List? imageFileBytes;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    final authCubit = context.read<AuthenticationCubit>();

    final userBackgroundColor = authCubit.currentUser?.backgroundColor;
    final userForegroundColor = authCubit.currentUser?.color;
    final appbarBackgroundColor = colorScheme.secondaryContainer;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => _backButton(context),
          icon: Icon(
            Icons.arrow_back_outlined,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.done),
            tooltip: 'Save',
            onPressed: () => _editProfileInfo(context),
          ),
        ],
        backgroundColor: appbarBackgroundColor,
        foregroundColor: userForegroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: FullImageAvatar(
                emptyImageContainerColor: appbarBackgroundColor,
                iconData: Icons.person_4,
                avatarBackgroundColor: userBackgroundColor,
                avatarForegroundColor: userForegroundColor,
                imageUrl: authCubit.currentUser?.imageUrl,
              ),
            ),
            // todo: add textField
          ],
        ),
      ),
    );
  }

  _editProfileInfo(BuildContext context) {
    // todo: _editProfileInfo
  }

  _backButton(BuildContext context) {
    context.pop();
  }
}
