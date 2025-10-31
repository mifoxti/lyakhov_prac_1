import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/player_model.dart';

class PlayerFormScreen extends StatefulWidget {
  final dynamic existingTrack;

  const PlayerFormScreen({
    super.key,
    this.existingTrack,
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
    if (widget.existingTrack != null && widget.existingTrack is Track) {
      _title = widget.existingTrack.title ?? '';
      _artist = widget.existingTrack.artist ?? '';
      _duration = widget.existingTrack.duration ?? '';
    } else {
      _title = '';
      _artist = '';
      _duration = '';
    }
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
      context.pop(track);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: Text(
          widget.existingTrack != null ? 'Редактировать трек' : 'Новый трек',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(
                  labelText: 'Название трека',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) =>
                value == null || value.isEmpty ? 'Введите название' : null,
                onSaved: (value) => _title = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _artist,
                decoration: const InputDecoration(
                  labelText: 'Исполнитель',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) =>
                value == null || value.isEmpty ? 'Введите исполнителя' : null,
                onSaved: (value) => _artist = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _duration,
                decoration: const InputDecoration(
                  labelText: 'Длительность (мм:сс)',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
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
                    onPressed: () => context.pop(),
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