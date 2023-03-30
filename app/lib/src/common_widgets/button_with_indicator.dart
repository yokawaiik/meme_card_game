import 'package:flutter/material.dart';

enum _ButtonType {
  tonal,
  tonalIcon,
}

class ButtonWithIndicator extends StatelessWidget {
  late final bool isLoading;
  late final void Function()? onPressed;
  late final Widget child;
  late final Widget icon;
  late final ButtonStyle? style;

  late _ButtonType _buttonType;

  ButtonWithIndicator.tonal({
    super.key,
    this.isLoading = false,
    required this.onPressed,
    required this.child,
    this.style,
  }) {
    _buttonType = _ButtonType.tonal;
  }

  ButtonWithIndicator.tonalIcon({
    super.key,
    this.isLoading = false,
    required this.onPressed,
    required label,
    required icon,
    this.style,
  }) {
    child = label;
    _buttonType = _ButtonType.tonalIcon;
  }

  Widget _buttonBuild() {
    switch (_buttonType) {
      case _ButtonType.tonal:
        return FilledButton.tonal(
          onPressed: onPressed,
          style: style,
          child: child,
        );
      case _ButtonType.tonalIcon:
        return FilledButton.tonalIcon(
          onPressed: onPressed,
          style: style,
          icon: icon,
          label: child,
        );
      default:
        throw Exception(
            "ButtonWithIndicator exception: such ButtonType doesn't exists.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: key,
      children: [
        if (isLoading)
          const Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        _buttonBuild(),
      ],
    );
  }
}
