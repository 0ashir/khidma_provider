enum WithDrawalStatusEnum {
  all("all", 9999),
  pending("pending", 0),
  approved("approved", 1),
  notApproved("rejected", 2),
  settled("settled", 3);

  final String name;
  final int value;

  const WithDrawalStatusEnum(this.name, this.value);

  static WithDrawalStatusEnum fromString(String status) {
    return WithDrawalStatusEnum.values.firstWhere(
      (e) => e.name == status,
      orElse: () => WithDrawalStatusEnum.pending,
    );
  }
}
