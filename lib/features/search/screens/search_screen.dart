import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int _searchResultsCount = 25;

  void _increaseResults() {
    if (_searchResultsCount < 100) {
      setState(() {
        _searchResultsCount += 5;
      });
    }
  }

  void _decreaseResults() {
    if (_searchResultsCount > 5) {
      setState(() {
        _searchResultsCount -= 5;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: const Text('Поиск музыки'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Текущее количество результатов
            Text(
              'Найдено треков:',
              style: TextStyle(
                fontSize: 20,
                color: Colors.deepPurple[700],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '$_searchResultsCount',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 30),

            // Поле поиска
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
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

            // Кнопка "Найти больше"
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: _increaseResults,
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

            // Кнопка "Уменьшить результаты"
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: _decreaseResults,
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

            // Популярные категории
            const Text(
              'Популярные категории:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  _buildCategoryChip('Поп'),
                  _buildCategoryChip('Рок'),
                  _buildCategoryChip('Хип-хоп'),
                  _buildCategoryChip('Электроника'),
                  _buildCategoryChip('Джаз'),
                  _buildCategoryChip('Классика'),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Кнопка "Вернуться на главный экран"
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple[300],
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  'Вернуться на главный экран',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.deepPurple[900],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String text) {
    return Chip(
      label: Text(text),
      backgroundColor: Colors.deepPurple[100],
      labelStyle: const TextStyle(color: Colors.deepPurple),
    );
  }
}