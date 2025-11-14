import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../cubit/search_cubit.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late SearchCubit _cubit;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cubit = SearchCubit();
  }

  @override
  void dispose() {
    _cubit.close();
    _searchController.dispose();
    super.dispose();
  }

  void _showEditResultsDialog(BuildContext context) {
    final controller = TextEditingController(text: _cubit.state.resultsCount.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Настройка результатов'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Укажите количество результатов поиска:'),
              const SizedBox(height: 15),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Количество треков',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                final count = int.tryParse(controller.text);
                if (count != null) {
                  _cubit.setCustomResultsCount(count);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Количество результатов установлено: $count'),
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

  void _showAddCategoryDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Добавить категорию'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Введите название новой категории:'),
              const SizedBox(height: 15),
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: 'Название категории',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                final category = controller.text.trim();
                if (category.isNotEmpty) {
                  _cubit.addFavoriteCategory(category);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Категория "$category" добавлена'),
                      backgroundColor: Colors.deepPurple,
                    ),
                  );
                }
                Navigator.of(context).pop();
              },
              child: const Text('Добавить'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: Colors.deepPurple[50],
        appBar: AppBar(
          title: const Text('Поиск музыки'),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.tune),
              onPressed: () => _showEditResultsDialog(context),
              tooltip: 'Настройки поиска',
            ),
          ],
        ),
        body: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        imageUrl: 'https://allforjoomla.ru/images/stories/b31ed032e74680d8aaae22c5fdf.jpg',
                        fit: BoxFit.cover,
                        progressIndicatorBuilder: (context, url, progress) =>
                            Container(
                              color: Colors.deepPurple[100],
                              child: const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                                ),
                              ),
                            ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.deepPurple[100],
                          child: const Center(
                            child: Icon(
                              Icons.music_note,
                              size: 50,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'Найдено треков:',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.deepPurple[700],
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => _showEditResultsDialog(context),
                    child: Text(
                      '${state.resultsCount}',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) => _cubit.updateQuery(value),
                      decoration: InputDecoration(
                        hintText: 'Поиск треков, альбомов, исполнителей...',
                        prefixIcon: const Icon(Icons.search, color: Colors.deepPurple),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: _cubit.increaseResults,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text(
                        'Найти больше',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: _cubit.decreaseResults,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple[200],
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: Text(
                        'Уменьшить результаты',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.deepPurple[800],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Популярные категории:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.deepPurple),
                        onPressed: () => _showAddCategoryDialog(context),
                        tooltip: 'Добавить категорию',
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: [
                        ...state.favoriteCategories.map((category) =>
                            _buildCategoryChip(category)
                        ).toList(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String text) {
    return Chip(
      label: Text(text),
      backgroundColor: Colors.deepPurple[100],
      labelStyle: const TextStyle(color: Colors.deepPurple),
      deleteIcon: const Icon(Icons.close, size: 18),
      onDeleted: () => _cubit.removeFavoriteCategory(text),
    );
  }
}