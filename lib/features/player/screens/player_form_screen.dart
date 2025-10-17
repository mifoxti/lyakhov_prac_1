import 'package:flutter/material.dart';
import '../models/player_model.dart';

class PlayerFormScreen extends StatefulWidget {
  final Track? existingTrack;
  final void Function(Track) onSave;
  final VoidCallback onCancel; // добавляем этот колбэк

  const PlayerFormScreen({
    super.key,
    this.existingTrack,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<PlayerFormScreen> createState() => _PlayerFormScreenState();
}

class _PlayerFormScreenState extends State<PlayerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _artist;
  late String _duration;

  @override
  void initState() {
    super.initState();
    _title = widget.existingTrack?.title ?? '';
    _artist = widget.existingTrack?.artist ?? '';
    _duration = widget.existingTrack?.duration ?? '';
  }

  void _save() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      final track = Track(
        id: widget.existingTrack?.id ?? DateTime.now().microsecondsSinceEpoch,
        title: _title,
        artist: _artist,
        duration: _duration,
      );
      widget.onSave(track);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingTrack != null ? 'Редактировать трек' : 'Новый трек'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Название трека'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Введите название' : null,
                onSaved: (value) => _title = value!,
              ),
              TextFormField(
                initialValue: _artist,
                decoration: const InputDecoration(labelText: 'Исполнитель'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Введите исполнителя' : null,
                onSaved: (value) => _artist = value!,
              ),
              TextFormField(
                initialValue: _duration,
                decoration: const InputDecoration(labelText: 'Длительность (мм:сс)'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Введите длительность' : null,
                onSaved: (value) => _duration = value!,
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30),
                    ),
                    child: const Text('Сохранить', style: TextStyle(fontSize: 16)),
                  ),
                  ElevatedButton(
                    onPressed: widget.onCancel,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30),
                    ),
                    child: const Text('Отмена', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
