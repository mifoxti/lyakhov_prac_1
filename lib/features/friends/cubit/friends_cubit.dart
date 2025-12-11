import 'package:flutter_bloc/flutter_bloc.dart';

class Friend {
  final int id;
  final String name;
  final String avatarUrl;
  final bool isOnline;
  final bool isInvited;

  Friend({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.isOnline,
    this.isInvited = false,
  });

  Friend copyWith({
    int? id,
    String? name,
    String? avatarUrl,
    bool? isOnline,
    bool? isInvited,
  }) {
    return Friend(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isOnline: isOnline ?? this.isOnline,
      isInvited: isInvited ?? this.isInvited,
    );
  }
}

class FriendsState {
  final List<Friend> friends;
  final bool isLoading;

  const FriendsState({
    this.friends = const [],
    this.isLoading = false,
  });

  FriendsState copyWith({
    List<Friend>? friends,
    bool? isLoading,
  }) {
    return FriendsState(
      friends: friends ?? this.friends,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  int get friendsCount => friends.length;
  int get onlineFriendsCount => friends.where((f) => f.isOnline).length;
  int get invitedFriendsCount => friends.where((f) => f.isInvited).length;
}

class FriendsCubit extends Cubit<FriendsState> {
  FriendsCubit() : super(const FriendsState()) {
    _loadInitialFriends();
  }

  void _loadInitialFriends() {
    emit(
      FriendsState(
        friends: [
          Friend(
            id: 1,
            name: 'Анна Петрова',
            avatarUrl: 'https://i.pinimg.com/736x/8d/1b/3b/8d1b3b8e3c8e4a8d1b3b8e3c8e4a8d1.jpg',
            isOnline: true,
          ),
          Friend(
            id: 2,
            name: 'Михаил Иванов',
            avatarUrl: 'https://i.pinimg.com/736x/9e/2c/4d/9e2c4d8e2c4d9e2c4d8e2c4d9e2c4d8e.jpg',
            isOnline: true,
          ),
          Friend(
            id: 3,
            name: 'Елена Сидорова',
            avatarUrl: 'https://i.pinimg.com/736x/7a/05/e2/7a05e28ac2cc660b976f03a70f84dba4.jpg',
            isOnline: false,
          ),
          Friend(
            id: 4,
            name: 'Дмитрий Кузнецов',
            avatarUrl: 'https://i.pinimg.com/736x/f9/63/6a/f9636a282f8d673219ddc29bdd742bd5.jpg',
            isOnline: true,
          ),
          Friend(
            id: 5,
            name: 'Ольга Васильева',
            avatarUrl: 'https://i.pinimg.com/736x/5a/8d/2b/5a8d2b5a8d2b5a8d2b5a8d2b5a8d2b5a.jpg',
            isOnline: false,
          ),
        ],
      ),
    );
  }

  void inviteFriend(int friendId) {
    final updatedFriends = state.friends.map((friend) {
      if (friend.id == friendId) {
        return friend.copyWith(isInvited: true);
      }
      return friend;
    }).toList();
    emit(state.copyWith(friends: updatedFriends));
  }

  void uninviteFriend(int friendId) {
    final updatedFriends = state.friends.map((friend) {
      if (friend.id == friendId) {
        return friend.copyWith(isInvited: false);
      }
      return friend;
    }).toList();
    emit(state.copyWith(friends: updatedFriends));
  }

  void sendInvitations() {
    // Simulate sending invitations
    final invitedFriends = state.friends.where((f) => f.isInvited).toList();
    // Here you would integrate with backend or sharing service
    // For now, just show success message
    emit(state.copyWith(isLoading: true));
    Future.delayed(const Duration(seconds: 2), () {
      emit(state.copyWith(isLoading: false));
      // Reset invitations after sending
      final resetFriends = state.friends.map((f) => f.copyWith(isInvited: false)).toList();
      emit(state.copyWith(friends: resetFriends));
    });
  }
}
