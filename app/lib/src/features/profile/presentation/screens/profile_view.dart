import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meme_card_game/src/features/auth/presentation/cubit/authentication_cubit.dart';

import '../../../../common_widgets/full_image_avatar.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final authCubit = context.read<AuthenticationCubit>();

    final userBackgroundColor = authCubit.currentUser?.backgroundColor;
    final userForegroundColor = authCubit.currentUser?.color;
    final appbarBackgroundColor = colorScheme.secondaryContainer;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile info"),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.edit),
        //     tooltip: 'Edit info',
        //     onPressed: () => _editProfileInfo(context),
        //   ),
        // ],
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
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
              const SizedBox(
                height: 10,
              ),
              Text(
                "Player name: @${authCubit.currentUser!.login}",
                style: const TextStyle(
                  // fontSize: textTheme.bodyMedium?.fontSize,
                  fontSize: 18,
                ),
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Center(
              child: FilledButton.icon(
                onPressed: () => _signOut(context),
                icon: const Icon(Icons.exit_to_app),
                label: const Text(
                  "Sign out",
                  style: TextStyle(
                    // fontSize: textTheme.bodyMedium?.fontSize,
                    fontSize: 18,
                  ),
                ),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(
                    100,
                    46,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _signOut(BuildContext context) async {
    try {
      final authCubit = context.read<AuthenticationCubit>();
      await authCubit.logOut();
    } catch (e) {
      if (kDebugMode) {
        print('ProfileView - _signOut - e : $e');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Something went wrong.",
          ),
        ),
      );
    }
  }
}
