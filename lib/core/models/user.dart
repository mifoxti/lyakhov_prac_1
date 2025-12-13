class MusicUser {
  final String id;
  final String login;
  final String displayName;
  final String subscriptionType;
  final String profileImageUrl;
  final bool isPremiumUser;

  const MusicUser({
    required this.id,
    required this.login,
    required this.displayName,
    required this.subscriptionType,
    required this.profileImageUrl,
    required this.isPremiumUser,
  });

  MusicUser copyWith({
    String? id,
    String? login,
    String? displayName,
    String? subscriptionType,
    String? profileImageUrl,
    bool? isPremiumUser,
  }) {
    return MusicUser(
      id: id ?? this.id,
      login: login ?? this.login,
      displayName: displayName ?? this.displayName,
      subscriptionType: subscriptionType ?? this.subscriptionType,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isPremiumUser: isPremiumUser ?? this.isPremiumUser,
    );
  }
}
