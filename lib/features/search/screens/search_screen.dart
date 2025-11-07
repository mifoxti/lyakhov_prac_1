import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
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
            Text(
              '$_searchResultsCount',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 30),
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