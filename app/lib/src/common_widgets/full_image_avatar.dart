import 'package:flutter/material.dart';

class FullImageAvatar extends StatelessWidget {
  final Color? emptyImageContainerColor;
  final Color? avatarForegroundColor;
  final Color? avatarBackgroundColor;
  final Size? size;
  String? imageUrl;

  final IconData iconData;

  FullImageAvatar({
    super.key,
    required this.imageUrl,
    required this.iconData,
    this.emptyImageContainerColor,
    this.avatarForegroundColor,
    this.avatarBackgroundColor,
    this.size,
  });

  FullImageAvatar.fromImageUrl({
    super.key,
    required this.imageUrl,
    required this.iconData,
    this.emptyImageContainerColor,
    this.avatarForegroundColor,
    this.avatarBackgroundColor,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final relevantSize = size ?? MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;

    final setAvatarForegroundColor =
        avatarForegroundColor ?? colorScheme.onPrimaryContainer;
    final setAvatarBackgroundColor =
        avatarBackgroundColor ?? colorScheme.primaryContainer;
    final setEmptyImageContainerColor =
        emptyImageContainerColor ?? colorScheme.secondaryContainer;

    if (imageUrl != null) {
      return Image.network(
        imageUrl!,
        width: double.infinity,
        height: relevantSize.height / 3,
      );
    } else {
      return Container(
        color: setEmptyImageContainerColor,
        width: double.infinity,
        height: relevantSize.height / 3,
        child: Center(
          child: CircleAvatar(
            backgroundColor: setAvatarBackgroundColor,
            radius: 90,
            child: Icon(
              // Icons.camera_alt,
              iconData,
              size: 100,
              color: setAvatarForegroundColor,
            ),
          ),
        ),
      );
    }
  }
}
