import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/password_entry.dart';
import '../services/storage_service.dart';
import 'password_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageService _storageService = StorageService();
  List<PasswordEntry> _passwords = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPasswords();
  }

  Future<void> _loadPasswords() async {
    setState(() => _isLoading = true);
    final passwords = await _storageService.getPasswords();
    setState(() {
      _passwords = passwords;
      _isLoading = false;
    });
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label copied to clipboard')),
    );
  }

  Future<void> _deletePassword(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Password?'),
        content: const Text('Are you sure you want to delete this entry?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _storageService.deletePassword(id);
      _loadPasswords();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Vault'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _passwords.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.security, size: 80, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'Your vault is empty.',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      const Text('Tap the + button to add a new password.'),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _passwords.length,
                  itemBuilder: (context, index) {
                    final entry = _passwords[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ExpansionTile(
                        leading: CircleAvatar(
                          child: Text(entry.title.isNotEmpty ? entry.title[0].toUpperCase() : '?'),
                        ),
                        title: Text(entry.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(entry.username),
                        childrenPadding: const EdgeInsets.all(16),
                        expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildDetailRow('Username', entry.username),
                          const SizedBox(height: 8),
                          _buildDetailRow('Password', '••••••••', realValue: entry.password),
                          if (entry.url.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            _buildDetailRow('URL', entry.url),
                          ],
                          if (entry.notes.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            const Text('Notes:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
                            const SizedBox(height: 4),
                            Text(entry.notes),
                          ],
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                onPressed: () => _deletePassword(entry.id),
                                icon: const Icon(Icons.delete, color: Colors.red),
                                label: const Text('Delete', style: TextStyle(color: Colors.red)),
                              ),
                              const SizedBox(width: 8),
                              FilledButton.icon(
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => PasswordFormScreen(entry: entry)),
                                  );
                                  _loadPasswords();
                                },
                                icon: const Icon(Icons.edit),
                                label: const Text('Edit'),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PasswordFormScreen()),
          );
          _loadPasswords();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDetailRow(String label, String displayValue, {String? realValue}) {
    final valueToCopy = realValue ?? displayValue;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
              Text(displayValue, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.copy, size: 20),
          onPressed: () => _copyToClipboard(valueToCopy, label),
          tooltip: 'Copy $label',
        ),
      ],
    );
  }
}