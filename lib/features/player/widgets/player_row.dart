import 'package:flutter/material.dart';

import '../../../../core/models/track.dart';

class PlayerRow extends StatelessWidget {
  final Track track;
  final bool isCurrent;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSelect;

  const PlayerRow({
    super.key,
    required this.track,
    required this.isCurrent,
    required this.onEdit,
    required this.onDelete,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.music_note,
          color: isCurrent ? Colors.deepPurple : Colors.deepPurple[300]),
      title: Text(
        track.title,
        style: TextStyle(
          fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
          color: Colors.deepPurple,
        ),
      ),
      subtitle: Text(
        '${track.artist} • ${track.duration}',
        style: TextStyle(color: Colors.deepPurple[600]),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: onEdit,
            icon: const Icon(Icons.edit, color: Colors.deepPurple),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
      onTap: onSelect,
    );
  }
}
