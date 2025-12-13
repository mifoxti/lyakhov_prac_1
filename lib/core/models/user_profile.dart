class UserProfile {
  final String name;
  final String institute;
  final String group;
  final int course;
  final String profileImageUrl;
  final String status;
  final int totalPlaytimeMinutes;
  final List<String> scientificActivities;

  const UserProfile({
    required this.name,
    required this.institute,
    required this.group,
    required this.course,
    required this.profileImageUrl,
    required this.status,
    required this.totalPlaytimeMinutes,
    required this.scientificActivities,
  });

  UserProfile copyWith({
    String? name,
    String? institute,
    String? group,
    int? course,
    String? profileImageUrl,
    String? status,
    int? totalPlaytimeMinutes,
    List<String>? scientificActivities,
  }) {
    return UserProfile(
      name: name ?? this.name,
      institute: institute ?? this.institute,
      group: group ?? this.group,
      course: course ?? this.course,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      status: status ?? this.status,
      totalPlaytimeMinutes: totalPlaytimeMinutes ?? this.totalPlaytimeMinutes,
      scientificActivities: scientificActivities ?? this.scientificActivities,
    );
  }

  int get totalPlaytimeHours => totalPlaytimeMinutes ~/ 60;
  int get remainingMinutes => totalPlaytimeMinutes % 60;
}
