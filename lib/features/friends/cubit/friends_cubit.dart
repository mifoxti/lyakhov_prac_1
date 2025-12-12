import 'package:flutter_bloc/flutter_bloc.dart';

class Friend {
  final int id;
  final String name;
  final String avatarUrl;
  final bool isOnline;
  final bool isInvited;
  final String? currentTrack;
  final String? currentArtist;

  Friend({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.isOnline,
    this.isInvited = false,
    this.currentTrack,
    this.currentArtist,
  });

  Friend copyWith({
    int? id,
    String? name,
    String? avatarUrl,
    bool? isOnline,
    bool? isInvited,
    String? currentTrack,
    String? currentArtist,
  }) {
    return Friend(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isOnline: isOnline ?? this.isOnline,
      isInvited: isInvited ?? this.isInvited,
      currentTrack: currentTrack ?? this.currentTrack,
      currentArtist: currentArtist ?? this.currentArtist,
    );
  }

  String get listeningStatus {
    if (isOnline && currentTrack != null && currentArtist != null) {
      return 'Слушает: $currentTrack — $currentArtist';
    }
    return isOnline ? 'Онлайн' : 'Оффлайн';
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
            avatarUrl: 'https://i.pinimg.com/736x/9f/ff/1d/9fff1d7c578bb2340f39caa500ff6e84.jpg',
            isOnline: true,
            currentTrack: 'Blinding Lights',
            currentArtist: 'The Weeknd',
          ),
          Friend(
            id: 2,
            name: 'Михаил Иванов',
            avatarUrl: 'https://i.pinimg.com/736x/a9/63/3c/a9633ccc839b0ce7319649ee7937d4a3.jpg',
            isOnline: true,
            currentTrack: 'Shape of You',
            currentArtist: 'Ed Sheeran',
          ),
          Friend(
            id: 3,
            name: 'Елена Сидорова',
            avatarUrl: 'https://i.pinimg.com/736x/c8/47/a2/c847a2d73aa6f9807ba431d2da38519b.jpg',
            isOnline: false,
          ),
          Friend(
            id: 4,
            name: 'Дмитрий Кузнецов',
            avatarUrl: 'https://i.pinimg.com/736x/c6/94/df/c694dfda012769f464ecaba36ba59d80.jpg',
            isOnline: true,
            currentTrack: 'Bohemian Rhapsody',
            currentArtist: 'Queen',
          ),
          Friend(
            id: 5,
            name: 'Ольга Васильева',
            avatarUrl: 'https://i.pinimg.com/736x/15/7b/7e/157b7e4b6bb0ac93acaacaec4a4cab6f.jpg',
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

  void joinFriend(int friendId) {
    // Simulate joining friend's listening session
    final friend = state.friends.firstWhere((f) => f.id == friendId);
    if (friend.isOnline && friend.currentTrack != null) {
      // Here you would start playing the same track as the friend
      // For now, we just show success
      emit(state.copyWith(isLoading: true));
      Future.delayed(const Duration(seconds: 1), () {
        emit(state.copyWith(isLoading: false));
      });
    }
  }
}
