import 'package:flutter/material.dart';
import '../models/player_model.dart';

class PlayerFormScreen extends StatefulWidget {
  final Track? existingTrack;
  final Function(Track) onSave;

  const PlayerFormScreen({super.key, this.existingTrack, required this.onSave});

  @override
  State<PlayerFormScreen> createState() => _PlayerFormScreenState();
}

class _PlayerFormScreenState extends State<PlayerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _artistController;
  late final TextEditingController _durationController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.existingTrack?.title ?? '');
    _artistController = TextEditingController(text: widget.existingTrack?.artist ?? '');
    _durationController = TextEditingController(text: widget.existingTrack?.duration ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _artistController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _saveTrack() {
    if (_formKey.currentState!.validate()) {
      final track = Track(
        id: widget.existingTrack?.id ?? DateTime.now().millisecondsSinceEpoch,
        title: _titleController.text.trim(),
        artist: _artistController.text.trim(),
        duration: _durationController.text.trim(),
      );
      widget.onSave(track);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existingTrack != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Редактировать трек' : 'Добавить трек'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Название трека',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Введите название трека' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _artistController,
                decoration: const InputDecoration(
                  labelText: 'Исполнитель',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Введите исполнителя' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(
                  labelText: 'Длительность (например: 3:45)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Введите длительность' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveTrack,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                ),
                child: Text(isEdit ? 'Сохранить' : 'Добавить',
                    style: const TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
