import 'dart:convert';

class PasswordEntry {
  final String id;
  final String title;
  final String username;
  final String password;
  final String url;
  final String notes;

  PasswordEntry({
    required this.id,
    required this.title,
    required this.username,
    required this.password,
    this.url = '',
    this.notes = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'username': username,
      'password': password,
      'url': url,
      'notes': notes,
    };
  }

  factory PasswordEntry.fromMap(Map<String, dynamic> map) {
    return PasswordEntry(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      username: map['username'] ?? '',
      password: map['password'] ?? '',
      url: map['url'] ?? '',
      notes: map['notes'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PasswordEntry.fromJson(String source) => PasswordEntry.fromMap(json.decode(source));
}