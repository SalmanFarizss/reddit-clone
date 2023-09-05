class UserModel{
  final String name;
  final String profile;
  final String banner;
  final String uid;
  final bool isGuest;
  final int karma;
  final List<String> awards;

//<editor-fold desc="Data Methods">
  const UserModel({
    required this.name,
    required this.profile,
    required this.banner,
    required this.uid,
    required this.isGuest,
    required this.karma,
    required this.awards,
  });
  UserModel copyWith({
    String? name,
    String? profile,
    String? banner,
    String? uid,
    bool? isGuest,
    int? karma,
    List<String>? awards,
  })=> UserModel(
      name: name ?? this.name,
      profile: profile ?? this.profile,
      banner: banner ?? this.banner,
      uid: uid ?? this.uid,
      isGuest: isGuest ?? this.isGuest,
      karma: karma ?? this.karma,
      awards: awards ?? this.awards,
    );
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profile': profile,
      'banner': banner,
      'uid': uid,
      'isGuest': isGuest,
      'karma': karma,
      'awards': awards,
    };
  }
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      profile: map['profile'] as String,
      banner: map['banner'] as String,
      uid: map['uid'] as String,
      isGuest: map['isGuest'] as bool,
      karma: map['karma'] as int,
      awards: List<String>.from(map['awards']),
    );
  }
//</editor-fold>
}
