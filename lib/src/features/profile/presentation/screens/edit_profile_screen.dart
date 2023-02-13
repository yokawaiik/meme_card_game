import 'dart:developer';
import 'dart:io';

import 'package:dice_bear/dice_bear.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:meme_card_game/src/features/auth/presentation/cubit/authentication_cubit.dart';

import '../../../../common_widgets/full_image_avatar.dart';
import '../../../../extensions/color_extension.dart';
import '../../../auth/domain/avatar_generator_api_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  Uint8List? imageFileBytes;

  // todo: delete generateAvatar
  void generateAvatar() async {
    final backgroundColor = ColorExtension.generateColor();

    final image = (await AvatarGeneratorApiService.generateRawRandomAvatar());

    final rf = (await AvatarGeneratorApiService.generateRandomAvatarFile());
    log('rf : ${rf?.uri}');

    final bytes = await image?.asRawSvgBytes();
    // final bytes = image?.svgUri.data?.contentAsBytes();
    log(bytes.toString());

    setState(() {
      imageFileBytes = bytes;
    });

    print('_EditProfileScreenState - initState - imageFile : $Uint8List');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    final backdropFilterColor = colorScheme.primaryContainer;

    final _authCubit = context.read<AuthenticationCubit>();

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
        backgroundColor: backdropFilterColor,
        foregroundColor: colorScheme.onPrimaryContainer,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // FullImageAvatar.fromSvgBytes(
              //   emptyImageContainerColor: backdropFilterColor,
              //   size: size,
              //   imageFileBytes: _authCubit.currentUser.imageUrl,
              // ),
              FullImageAvatar(
                emptyImageContainerColor: backdropFilterColor,
                imageUrl: _authCubit.currentUser?.imageUrl,
                isImageSvg: _authCubit.currentUser?.isAvatartSvg,
              ),
            ],
          ),
          ElevatedButton(onPressed: generateAvatar, child: Text("Generate")),

          // if (imageFileBytes != null) Image.memory(imageFileBytes!)
          // if (imageFileBytes != null) SvgPicture.memory(imageFileBytes!)
        ],
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
