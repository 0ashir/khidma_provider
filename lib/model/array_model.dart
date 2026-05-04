class DashboardList {
  final String title;
  final String icon;
  final String icon2;

  DashboardList({required this.title, required this.icon, required this.icon2});

  // Factory method to create a MenuItem from a map
  factory DashboardList.fromMap(Map<String, dynamic> map) {
    return DashboardList(
      title: map['title'],
      icon: map['icon'],
      icon2: map['icon2'],
    );
  }

  // Method to convert a MenuItem into a map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'icon': icon,
      'icon2': icon2,
    };
  }
}
