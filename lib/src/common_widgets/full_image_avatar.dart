import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FullImageAvatar extends StatelessWidget {
  final Color? emptyImageContainerColor;
  final Size? size;
  Uint8List? imageFileBytes;
  String? imageUrl;
  bool? isImageSvg;

  FullImageAvatar({
    super.key,
    required this.imageUrl,
    this.imageFileBytes,
    this.emptyImageContainerColor,
    this.size,
    this.isImageSvg = false,
  });

  FullImageAvatar.fromImageUrl({
    super.key,
    required this.imageUrl,
    this.emptyImageContainerColor,
    this.size,
    this.isImageSvg = false,
  });

  FullImageAvatar.fromSvgBytes({
    super.key,
    required this.imageFileBytes,
    this.emptyImageContainerColor,
    this.size,
    this.isImageSvg = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final relevantSize = size ?? MediaQuery.of(context).size;

    print("imageUrl : $imageUrl");
    print("isImageSvg : $isImageSvg");

    if (imageUrl != null) {
      if (isImageSvg == false) {
        return Image.network(
          imageUrl!,
          width: double.infinity,
          height: relevantSize.height / 3,
        );
      } else {
        return Center(
          // TODO ERROR : correct error. doesnt show svg network
          child: SvgPicture.network(
            imageUrl!,
            width: double.infinity,
            height: relevantSize.height / 3,
          ),
        );
      }
    } else {
      return Container(
        color: emptyImageContainerColor,
        width: double.infinity,
        height: relevantSize.height / 3,
        child: CircleAvatar(
          backgroundColor: colorScheme.primaryContainer,
          radius: 50,
          child: Icon(
            Icons.camera_alt,
            size: 150,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
      );
    }
  }
}
