// lib/features/library/screens/library_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import '../cubit/library_cubit.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late LibraryCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = LibraryCubit();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _showAddDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Новый плейлист'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Название'),
          ),
          actions: [
            TextButton(onPressed: Navigator.of(context).pop, child: const Text('Отмена')),
            ElevatedButton(
              onPressed: () {
                final name = controller.text.trim();
                if (name.isNotEmpty) {
                  _cubit.addPlaylist(name); // ← используем локальный кубит
                }
                Navigator.of(context).pop();
                if (name.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Плейлист "$name" создан'), backgroundColor: Colors.deepPurple),
                  );
                }
              },
              child: const Text('Создать'),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, int index, String currentName) {
    final controller = TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Редактировать плейлист'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Новое название'),
          ),
          actions: [
            TextButton(onPressed: Navigator.of(context).pop, child: const Text('Отмена')),
            ElevatedButton(
              onPressed: () {
                final name = controller.text.trim();
                if (name.isNotEmpty && name != currentName) {
                  _cubit.updatePlaylist(index, name); // ← используем локальный кубит
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Плейлист переименован в "$name"'), backgroundColor: Colors.deepPurple),
                  );
                }
                Navigator.of(context).pop();
              },
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }

  void _removePlaylist(BuildContext context, int index, String name) {
    _cubit.removePlaylist(index); // ← используем локальный кубит
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Плейлист "$name" удалён'), backgroundColor: Colors.deepPurple[300]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: Colors.deepPurple[50],
        appBar: AppBar(
          title: const Text('Моя библиотека'),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: context.pop),
        ),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.deepPurple.withOpacity(0.3), blurRadius: 10, spreadRadius: 2, offset: const Offset(0, 4)),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: 'https://i.pinimg.com/736x/7a/05/e2/7a05e28ac2cc660b976f03a70f84dba4.jpg',
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, progress) => Container(
                    color: Colors.deepPurple[100],
                    child: const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple))),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.deepPurple[100],
                    child: const Center(child: Icon(Icons.library_music, size: 60, color: Colors.deepPurple)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text('Количество плейлистов:', style: TextStyle(fontSize: 20, color: Colors.deepPurple[700])),
                  const SizedBox(height: 10),
                  BlocBuilder<LibraryCubit, LibraryState>(
                    builder: (context, state) {
                      return Text('${state.playlistCount}', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.deepPurple));
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () => _showAddDialog(context),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, padding: const EdgeInsets.symmetric(vertical: 15)),
                      child: const Text('Добавить плейлист', style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<LibraryCubit, LibraryState>(
                builder: (context, state) {
                  return ListView.builder(
                    itemCount: state.playlists.length,
                    itemBuilder: (context, index) {
                      final playlist = state.playlists[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: ListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.deepPurple[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.queue_music, color: Colors.deepPurple),
                          ),
                          title: Text(playlist.name, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.deepPurple)),
                          subtitle: Text('${playlist.trackCount} треков'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () => _showEditDialog(context, index, playlist.name),
                                icon: const Icon(Icons.edit, color: Colors.deepPurple),
                                tooltip: 'Редактировать',
                              ),
                              IconButton(
                                onPressed: () => _removePlaylist(context, index, playlist.name),
                                icon: const Icon(Icons.delete, color: Colors.red),
                                tooltip: 'Удалить',
                              ),
                              const Icon(Icons.play_arrow, color: Colors.deepPurple),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}