import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import 'home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final StorageService _storageService = StorageService();
  final TextEditingController _passwordController = TextEditingController();
  
  bool _isLoading = true;
  bool _hasMasterPassword = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _checkMasterPassword();
  }

  Future<void> _checkMasterPassword() async {
    final hasPassword = await _storageService.hasMasterPassword();
    setState(() {
      _hasMasterPassword = hasPassword;
      _isLoading = false;
    });
  }

  Future<void> _submit() async {
    final password = _passwordController.text.trim();
    if (password.isEmpty) {
      setState(() => _errorMessage = 'Password cannot be empty');
      return;
    }

    if (_hasMasterPassword) {
      final isValid = await _storageService.verifyMasterPassword(password);
      if (isValid) {
        _navigateToHome();
      } else {
        setState(() => _errorMessage = 'Incorrect password');
      }
    } else {
      await _storageService.setMasterPassword(password);
      _navigateToHome();
    }
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline, size: 80, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 24),
              Text(
                _hasMasterPassword ? 'Unlock Vault' : 'Create Master Password',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                _hasMasterPassword
                    ? 'Enter your master password to access your vault.'
                    : 'Set a secure master password to protect your data.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Master Password',
                  errorText: _errorMessage.isEmpty ? null : _errorMessage,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.key),
                ),
                onSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _submit,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(_hasMasterPassword ? 'Unlock' : 'Save & Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}