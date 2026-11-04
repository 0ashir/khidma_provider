class ChatParticipant {
  final int id;
  final String name;
  final String profileImage;

  const ChatParticipant({
    required this.id,
    required this.name,
    required this.profileImage,
  });

  factory ChatParticipant.fromJson(Map<String, dynamic> json) {
    return ChatParticipant(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      profileImage: json['profile_image']?.toString() ?? '',
    );
  }
}
