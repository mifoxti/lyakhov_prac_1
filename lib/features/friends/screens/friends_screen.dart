import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import '../cubit/friends_cubit.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  late FriendsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = FriendsCubit();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: Colors.deepPurple[50],
        appBar: AppBar(
          title: const Text('Пригласить друзей'),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: context.pop),
        ),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Colors.deepPurple, Colors.purpleAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(color: Colors.deepPurple.withOpacity(0.3), blurRadius: 10, spreadRadius: 2, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'Совместное прослушивание',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Выберите друзей для приглашения в комнату',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: BlocBuilder<FriendsCubit, FriendsState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Друзья (${state.friendsCount})',
                            style: TextStyle(fontSize: 20, color: Colors.deepPurple[700], fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Онлайн: ${state.onlineFriendsCount}',
                            style: TextStyle(fontSize: 16, color: Colors.deepPurple[600]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (state.invitedFriendsCount > 0)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.check_circle, color: Colors.green),
                              const SizedBox(width: 8),
                              Text(
                                'Выбрано для приглашения: ${state.invitedFriendsCount}',
                                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: BlocBuilder<FriendsCubit, FriendsState>(
                builder: (context, state) {
                  return ListView.builder(
                    itemCount: state.friends.length,
                    itemBuilder: (context, index) {
                      final friend = state.friends[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: ListTile(
                          leading: Stack(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(friend.avatarUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              if (friend.isOnline)
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.white, width: 2),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          title: Text(
                            friend.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: friend.isOnline ? Colors.deepPurple : Colors.grey,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                friend.isOnline ? 'Онлайн' : 'Оффлайн',
                                style: TextStyle(
                                  color: friend.isOnline ? Colors.green : Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              if (friend.isOnline && friend.currentTrack != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    '🎵 ${friend.currentTrack} — ${friend.currentArtist}',
                                    style: const TextStyle(
                                      color: Colors.deepPurple,
                                      fontSize: 11,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                            ],
                          ),
                          trailing: friend.isOnline && friend.currentTrack != null
                              ? ElevatedButton.icon(
                                  onPressed: () {
                                    _cubit.joinFriend(friend.id);
                                    // Переходим на плеер с треком друга
                                    context.push(
                                      '/main/player?track=${Uri.encodeComponent(friend.currentTrack!)}&artist=${Uri.encodeComponent(friend.currentArtist!)}',
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Присоединяемся к ${friend.name}...'),
                                        backgroundColor: Colors.deepPurple,
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurple,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  ),
                                  icon: const Icon(Icons.headphones, size: 16, color: Colors.white),
                                  label: const Text(
                                    'Присоединиться',
                                    style: TextStyle(color: Colors.white, fontSize: 12),
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: friend.isOnline ? () {
                                    if (friend.isInvited) {
                                      _cubit.uninviteFriend(friend.id);
                                    } else {
                                      _cubit.inviteFriend(friend.id);
                                    }
                                  } : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: friend.isInvited ? Colors.red : Colors.deepPurple,
                                    disabledBackgroundColor: Colors.grey,
                                  ),
                                  child: Text(
                                    friend.isInvited ? 'Отменить' : 'Пригласить',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            BlocBuilder<FriendsCubit, FriendsState>(
              builder: (context, state) {
                if (state.invitedFriendsCount > 0) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    color: Colors.white,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state.isLoading ? null : () {
                          _cubit.sendInvitations();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Приглашения отправлены!'),
                              backgroundColor: Colors.deepPurple,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: state.isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                'Отправить приглашения',
                                style: TextStyle(fontSize: 18, color: Colors.white),
                              ),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
