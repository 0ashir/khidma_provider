class AssignedHandymanModel {
  final String id;
  final String username;
  final String image;
  final bool isLead;
  // Non-null means this handyman has a conflicting booking at the same time.
  // Only populated on assignable_handymen entries; always null on assigned_handymen.
  final String? conflictingOrderId;
  // Populated on handyman-side assigned_handymen entries (handyman_status/status).
  final String? status;

  const AssignedHandymanModel({
    required this.id,
    required this.username,
    required this.image,
    required this.isLead,
    this.conflictingOrderId,
    this.status,
  });

  bool get hasConflict => conflictingOrderId != null;

  // Aliases used by handyman-side UI.
  String get displayName => username;
  String get profileImage => image;

  factory AssignedHandymanModel.fromJson(Map<String, dynamic> json) {
    return AssignedHandymanModel(
      id: json['id']?.toString() ?? '',
      username: json['display_name']?.toString() ??
          json['username']?.toString() ?? '',
      image: json['image']?.toString() ??
          json['profile_image']?.toString() ?? '',
      isLead: json['is_lead'] == true ||
          json['is_lead']?.toString() == '1' ||
          json['is_lead'] == 1,
      conflictingOrderId: json['conflicting_order_id']?.toString(),
      status: json['handyman_status']?.toString() ??
          json['status']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'image': image,
    'is_lead': isLead ? 1 : 0,
    'conflicting_order_id': conflictingOrderId,
    'status': status,
  };

  AssignedHandymanModel copyWith({
    String? id,
    String? username,
    String? image,
    bool? isLead,
    String? conflictingOrderId,
    String? status,
  }) {
    return AssignedHandymanModel(
      id: id ?? this.id,
      username: username ?? this.username,
      image: image ?? this.image,
      isLead: isLead ?? this.isLead,
      conflictingOrderId: conflictingOrderId ?? this.conflictingOrderId,
      status: status ?? this.status,
    );
  }
}
