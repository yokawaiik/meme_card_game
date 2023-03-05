import 'package:flutter/material.dart';

class PlayerListTile extends StatelessWidget {
  final String id;
  final String login;
  final Color? backgroundColor;
  final Color? color;
  final int points;
  final bool? isConfirm;
  void Function()? onTap;

  PlayerListTile({
    super.key,
    required this.id,
    required this.login,
    this.backgroundColor,
    this.color,
    required this.points,
    this.onTap,
    required,
    this.isConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      key: Key(id),
      leading: CircleAvatar(
        backgroundColor: backgroundColor,
        foregroundColor: color,
        child: const Icon(Icons.person_4),
      ),
      title: Text(
        login,
        overflow: TextOverflow.fade,
        maxLines: 1,
      ),
      trailing: isConfirm != null
          ? Checkbox(
              onChanged: null,
              value: isConfirm,
            )
          : null,
      subtitle: Row(
        children: [
          Text("Points: ${points}"),
        ],
      ),
    );
  }
}
