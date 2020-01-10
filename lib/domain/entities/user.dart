/// A user of the application.
class User {
  /// The user's first name.
  final String user_name;

  final String name;

  /// The user's last name.
  final String password;

  final String email;


  /// The user's initials in all caps.
  String get initials => '${user_name[0]}'.toUpperCase();

  /// The user's full name separated by a space.
  String get fullName => '$user_name';

  User(this.user_name, this.name, this.password,this.email);

  User.fromUser(User user)
      : user_name = user.user_name,
        name = user.name,
        password = user.password,
        email = user.email;

  User.fromJson(Map<String, dynamic> map)
      : user_name = map['user_name'],
        name = map['name'],
        password = map['password'],
        email = map['email'];

  /// Convert [this] to a Json `Map<String, dynamic>`. Complex structures keep their initial
  /// types.
  Map<String, dynamic> toJson() => {
        'user_name': user_name,
        'name': name,
        'password': password,
        'email': email
      };

  /// Convert [this] to a Json `Map<String, String>`. All complex structures
  /// are also converted to `String`.
  Map<String, String> toJson2() => {
        'user_name': user_name,
        'name': name,
        'password': password,
        'email': email
      };

  @override
  operator ==(dynamic user) => user is User && user_name == user.user_name;

  @override
  int get hashCode =>
      user_name.hashCode ^ name.hashCode ^ password.hashCode^email.hashCode;
}
