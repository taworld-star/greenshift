import 'package:flutter/material.dart';
import 'package:greenshift/data/repository/auth_repository.dart';
import 'package:greenshift/data/usecase/request/register_request.dart';
import 'package:greenshift/presentation/widgets/custom_text_field.dart';
import 'package:greenshift/presentation/widgets/green_button.dart';
import 'package:greenshift/presentation/widgets/green_header.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authRepository = AuthRepository();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final request = RegisterRequest(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      passwordConfirmation: _confirmPasswordController.text,
    );

    final response = await _authRepository.register(request);

   if (!mounted) return;
    setState(() => _isLoading = false);

    if (response != null && response.success) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } else {
      setState(() {
        _errorMessage = response?.message ?? 'Registrasi Akun gagal';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const GreenHeader(
              title: 'GreenShift',
              subtitle: 'Pelajari cara mengelola sampah dengan benar',
              
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitle(),
                      const SizedBox(height: 24),
                      _buildErrorMessage(),
                      _buildNamaField(),
                      const SizedBox(height: 16),
                      _buildEmailField(),
                      const SizedBox(height:16),
                      _buildPasswordField(),
                      const SizedBox(height: 16),
                      _buildConfirmPasswordField(),
                      const SizedBox(height: 24),
                      _buildTombolDaftar(),
                      const SizedBox(height: 24),
                      _buildLinkLogin(),
                ],
              )),
            )
          ],
        ),
      ),
    );
  }

   Widget _buildTitle() {
    return const Text(
      'Buat Akun Baru',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildErrorMessage() {
    if (_errorMessage == null) return const SizedBox.shrink();

      return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade700),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _errorMessage!,
              style: TextStyle(color: Colors.red.shade700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNamaField() {
    return CustomTextField(
      label: 'Nama Lengkap',
      hintText: 'Masukkan nama lengkap anda',
      controller: _nameController,
      prefixIcon: Icons.person_outlined,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Nama tidak boleh kosong';
        }
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return CustomTextField(
      label: 'Email',
      hintText: 'Masukkan email anda',
      controller: _emailController,
      prefixIcon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email tidak boleh kosong';
        }
        if (!value.contains('@') || !(value.contains('.com') || value.contains('.id') || value.contains('student.uisi.ac.id'))) {
          return 'Email tidak valid';
        }
        return null;
      },
    );
  }

    Widget _buildPasswordField() {
    return CustomTextField(
      label: 'Password',
      hintText: 'Masukkan password anda',
      controller: _passwordController,
      prefixIcon: Icons.lock_outlined,
      obscureText: _obscurePassword,
      suffixIcon: IconButton(
        icon: Icon(
          _obscurePassword ? Icons.visibility_off : Icons.visibility,
        ),
        onPressed: () {
          setState(() => _obscurePassword = !_obscurePassword);
        },
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password tidak boleh kosong';
        }
        if (value.length < 6) {
          return 'Password minimal 6 karakter';
        }
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return CustomTextField(
      label: 'Konfirmasi Password',
      hintText: 'Masukkan ulang password anda',
      controller: _confirmPasswordController,
      prefixIcon: Icons.lock_outlined,
      obscureText: _obscureConfirmPassword,
      suffixIcon: IconButton(
        icon: Icon(
          _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
        ),
        onPressed: () {
          setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
        },
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Konfirmasi password tidak boleh kosong';
        }
        if (value != _passwordController.text) {
          return 'Password tidak sama';
        }
        return null;
      },
    );
  }

  Widget _buildTombolDaftar() {
    return GreenButton(
      text: 'Daftar',
      onPressed: _register,
      isLoading: _isLoading,
    );
  }

  Widget _buildLinkLogin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Sudah punya akun? '),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Text(
            'Masuk',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

