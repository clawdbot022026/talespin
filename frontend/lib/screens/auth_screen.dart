import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';

class AuthScreen extends StatefulWidget {
  final bool initialIsLogin;

  const AuthScreen({Key? key, this.initialIsLogin = true}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late bool isLogin;
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    isLogin = widget.initialIsLogin;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final email = _emailController.text.trim();

    if (username.isEmpty || password.isEmpty || (!isLogin && email.isEmpty)) {
      setState(() => _errorMessage = "Please fill in all dimensional parameters.");
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (isLogin) {
        await authProvider.startLogin(username, password);
      } else {
        await authProvider.startRegister(username, email, password);
      }
      
      if (!mounted) return;
      // Close the modal upon success
      Navigator.of(context).pop(true);
      
    } catch (e) {
      if (!mounted) return;
      setState(() => _errorMessage = e.toString().replaceFirst("Exception: ", ""));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppTheme.cyanAccent),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Icon(Icons.blur_on, size: 80, color: AppTheme.cyanAccent.withValues(alpha: 0.8)),
              const SizedBox(height: 20),
              Text(
                isLogin ? 'Welcome Back' : 'Join the Cult',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 32,
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textLight,
                  shadows: [Shadow(blurRadius: 10, color: AppTheme.cyanAccent, offset: Offset(0, 0))],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                isLogin ? 'Resume altering reality.' : 'Forge your first timeline.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppTheme.textMuted, fontSize: 16),
              ),
              const SizedBox(height: 50),

              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: AppTheme.magentaAccent.withValues(alpha: 0.1),
                    border: Border.all(color: AppTheme.magentaAccent),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: AppTheme.magentaAccent),
                    textAlign: TextAlign.center,
                  ),
                ),

              // Form Fields
              TextField(
                controller: _usernameController,
                style: const TextStyle(color: AppTheme.textLight),
                decoration: InputDecoration(
                  labelText: 'Voyager Alias',
                  labelStyle: const TextStyle(color: AppTheme.textMuted),
                  filled: true,
                  fillColor: AppTheme.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  prefixIcon: const Icon(Icons.person, color: AppTheme.cyanAccent),
                ),
              ),
              const SizedBox(height: 16),

              if (!isLogin) ...[
                TextField(
                  controller: _emailController,
                  style: const TextStyle(color: AppTheme.textLight),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Communication Link (Email)',
                    labelStyle: const TextStyle(color: AppTheme.textMuted),
                    filled: true,
                    fillColor: AppTheme.surface,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    prefixIcon: const Icon(Icons.email, color: AppTheme.cyanAccent),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              TextField(
                controller: _passwordController,
                style: const TextStyle(color: AppTheme.textLight),
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Chronal Passcode',
                  labelStyle: const TextStyle(color: AppTheme.textMuted),
                  filled: true,
                  fillColor: AppTheme.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  prefixIcon: const Icon(Icons.lock, color: AppTheme.cyanAccent),
                ),
              ),
              const SizedBox(height: 40),

              SizedBox(
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.cyanAccent,
                    foregroundColor: AppTheme.background,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 10,
                    shadowColor: AppTheme.cyanAccent.withValues(alpha: 0.5),
                  ),
                  child: _isLoading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: AppTheme.background, strokeWidth: 3))
                      : Text(isLogin ? "Synchronize" : "Enter the Multiverse", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20),

              TextButton(
                onPressed: () {
                  setState(() {
                    isLogin = !isLogin;
                    _errorMessage = null;
                  });
                },
                child: Text(
                  isLogin ? "Don't have an existence? Forge one." : "Already an entity? Synchronize instead.",
                  style: const TextStyle(color: AppTheme.textMuted),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
