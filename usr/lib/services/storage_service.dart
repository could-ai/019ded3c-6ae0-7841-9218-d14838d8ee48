import 'package:shared_preferences/shared_preferences.dart';
import '../models/password_entry.dart';

class StorageService {
  static const String _passwordsKey = 'vault_passwords';
  static const String _masterPasswordKey = 'vault_master_password';

  Future<bool> hasMasterPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_masterPasswordKey);
  }

  Future<bool> verifyMasterPassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_masterPasswordKey);
    return stored == password;
  }

  Future<void> setMasterPassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_masterPasswordKey, password);
  }

  Future<List<PasswordEntry>> getPasswords() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? data = prefs.getStringList(_passwordsKey);
    if (data == null) {
      return [];
    }
    return data.map((e) => PasswordEntry.fromJson(e)).toList();
  }

  Future<void> savePassword(PasswordEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final passwords = await getPasswords();
    final index = passwords.indexWhere((p) => p.id == entry.id);
    if (index >= 0) {
      passwords[index] = entry;
    } else {
      passwords.add(entry);
    }
    await prefs.setStringList(_passwordsKey, passwords.map((e) => e.toJson()).toList());
  }

  Future<void> deletePassword(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final passwords = await getPasswords();
    passwords.removeWhere((p) => p.id == id);
    await prefs.setStringList(_passwordsKey, passwords.map((e) => e.toJson()).toList());
  }
}