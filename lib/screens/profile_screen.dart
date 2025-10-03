import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentStatusIndex = 0;
  final List<String> _statuses = [
    'Онлайн',
    'Не беспокоить',
    'Оффлайн',
    'В пути',
    'В работе'
  ];

  void _changeStatus() {
    setState(() {
      _currentStatusIndex = (_currentStatusIndex + 1) % _statuses.length;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Статус изменен на: ${_statuses[_currentStatusIndex]}'),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: const Text('Мой профиль'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Аватар пользователя
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.deepPurple[100],
                shape: BoxShape.circle,
                border: Border.all(color: Colors.deepPurple, width: 3),
              ),
              child: const Icon(
                Icons.person,
                size: 60,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 20),

            // Имя пользователя
            const Text(
              'Тимофей Ляхов',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 10),

            // Текущий статус
            Text(
              _statuses[_currentStatusIndex],
              style: TextStyle(
                fontSize: 16,
                color: Colors.deepPurple[700],
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 30),

            // Статистика
            const Text(
              'Музыкальная статистика:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem('5', 'Плейлистов'),
                _buildStatItem('25', 'Найдено треков'),
                _buildStatItem('128', 'Всего треков'),
              ],
            ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem('28', 'Часов'),
                _buildStatItem('15', 'Исполнителей'),
                _buildStatItem('8', 'Альбомов'),
              ],
            ),
            const SizedBox(height: 40),

            // Кнопка "Сменить статус"
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: _changeStatus,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  'Сменить статус',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Настройки
            const Text(
              'Настройки аккаунта:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 15),

            _buildSettingItem('Редактировать профиль', Icons.edit),
            _buildSettingItem('Настройки приватности', Icons.security),
            _buildSettingItem('Качество звука', Icons.volume_up),
            _buildSettingItem('Уведомления', Icons.notifications),
            const SizedBox(height: 20),

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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.deepPurple[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSettingItem(String text, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(
          text,
          style: const TextStyle(color: Colors.deepPurple),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.deepPurple),
        onTap: () {},
      ),
    );
  }
}