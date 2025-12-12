import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import '../cubit/podcasts_cubit.dart';

class PodcastsScreen extends StatefulWidget {
  const PodcastsScreen({super.key});

  @override
  State<PodcastsScreen> createState() => _PodcastsScreenState();
}

class _PodcastsScreenState extends State<PodcastsScreen> {
  late PodcastsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = PodcastsCubit();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _showAddDialog(BuildContext context) {
    final titleController = TextEditingController();
    final authorController = TextEditingController();
    final durationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Новый подкаст'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Название подкаста'),
                ),
                TextField(
                  controller: authorController,
                  decoration: const InputDecoration(labelText: 'Автор'),
                ),
                TextField(
                  controller: durationController,
                  decoration: const InputDecoration(labelText: 'Длительность'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: Navigator.of(context).pop, child: const Text('Отмена')),
            ElevatedButton(
              onPressed: () {
                final title = titleController.text.trim();
                final author = authorController.text.trim();
                final duration = durationController.text.trim();

                if (title.isNotEmpty && author.isNotEmpty) {
                  _cubit.addPodcast(title, author, duration.isNotEmpty ? duration : '30:00');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Подкаст "$title" добавлен'), backgroundColor: Colors.deepPurple),
                  );
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Добавить'),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, int index, Podcast currentPodcast) {
    final titleController = TextEditingController(text: currentPodcast.title);
    final authorController = TextEditingController(text: currentPodcast.author);
    final durationController = TextEditingController(text: currentPodcast.duration);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Редактировать подкаст'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Название подкаста'),
                ),
                TextField(
                  controller: authorController,
                  decoration: const InputDecoration(labelText: 'Автор'),
                ),
                TextField(
                  controller: durationController,
                  decoration: const InputDecoration(labelText: 'Длительность'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedPodcast = Podcast(
                  id: currentPodcast.id,
                  title: titleController.text.trim(),
                  author: authorController.text.trim(),
                  duration: durationController.text.trim(),
                  imageUrl: currentPodcast.imageUrl,
                );
                if (updatedPodcast.title.isNotEmpty && updatedPodcast.author.isNotEmpty) {
                  _cubit.updatePodcast(index, updatedPodcast);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Подкаст "${updatedPodcast.title}" обновлен'),
                      backgroundColor: Colors.deepPurple,
                    ),
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

  void _removePodcast(BuildContext context, int index, String podcastName) {
    _cubit.removePodcast(index);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Подкаст "$podcastName" удалён'), backgroundColor: Colors.deepPurple[300]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: Colors.deepPurple[50],
        appBar: AppBar(
          title: const Text('Мои подкасты'),
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
                  imageUrl: 'https://i.pinimg.com/736x/5a/8d/2b/5a8d2b5a8d2b5a8d2b5a8d2b5a8d2b5a.jpg',
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, progress) => Container(
                    color: Colors.deepPurple[100],
                    child: const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple))),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.deepPurple[100],
                    child: const Center(child: Icon(Icons.podcasts, size: 60, color: Colors.deepPurple)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text('Количество подкастов:', style: TextStyle(fontSize: 20, color: Colors.deepPurple[700])),
                  const SizedBox(height: 10),
                  BlocBuilder<PodcastsCubit, PodcastState>(
                    builder: (context, state) {
                      return Text('${state.podcastCount}', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.deepPurple));
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () => _showAddDialog(context),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, padding: const EdgeInsets.symmetric(vertical: 15)),
                      child: const Text('Добавить подкаст', style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<PodcastsCubit, PodcastState>(
                builder: (context, state) {
                  return ListView.builder(
                    itemCount: state.podcasts.length,
                    itemBuilder: (context, index) {
                      final podcast = state.podcasts[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: ListTile(
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(podcast.imageUrl.isNotEmpty ? podcast.imageUrl : 'https://via.placeholder.com/50x50?text=🎙️'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text(podcast.title, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.deepPurple)),
                          subtitle: Text('${podcast.author} • ${podcast.duration}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () => _showEditDialog(context, index, podcast),
                                icon: const Icon(Icons.edit, color: Colors.deepPurple),
                                tooltip: 'Редактировать',
                              ),
                              IconButton(
                                onPressed: () => _removePodcast(context, index, podcast.title),
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
