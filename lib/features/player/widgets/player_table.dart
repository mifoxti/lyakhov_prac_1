import 'package:flutter/material.dart';
import '../models/player_model.dart';
import 'player_row.dart';

class PlayerTable extends StatelessWidget {
  final List<Track> tracks;
  final int currentIndex;
  final Function(int) onEdit;
  final Function(int) onDelete;
  final Function(int) onSelect;

  const PlayerTable({
    super.key,
    required this.tracks,
    required this.currentIndex,
    required this.onEdit,
    required this.onDelete,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    if (tracks.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          'Треки отсутствуют',
          style: TextStyle(color: Colors.deepPurple, fontSize: 16),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tracks.length,
      separatorBuilder: (_, __) => const Divider(color: Colors.grey, height: 1),
      itemBuilder: (context, index) {
        final track = tracks[index];
        return PlayerRow(
          track: track,
          isCurrent: index == currentIndex,
          onEdit: () => onEdit(index),
          onDelete: () => onDelete(index),
          onSelect: () => onSelect(index),
        );
      },
    );
  }
}
