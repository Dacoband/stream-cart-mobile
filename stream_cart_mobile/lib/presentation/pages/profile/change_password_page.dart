import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/auth/change_password_request_entity.dart';
import '../../blocs/auth/change_password/change_password_bloc.dart';
import '../../blocs/auth/change_password/change_password_event.dart';
import '../../blocs/auth/change_password/change_password_state.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) return;
    final request = ChangePasswordRequestEntity(
      currentPassword: _currentController.text.trim(),
      newPassword: _newController.text.trim(),
      confirmNewPassword: _confirmController.text.trim(),
    );
    context.read<ChangePasswordBloc>().add(SubmitChangePasswordEvent(request));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Đổi mật khẩu',
          style: TextStyle(color: Color(0xFFB0F847), fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.1),
        ),
        backgroundColor: const Color(0xFF202328),
        iconTheme: const IconThemeData(color: Color(0xFFB0F847)),
      ),
      body: BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
        listener: (context, state) {
          if (state is ChangePasswordFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          } else if (state is ChangePasswordSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.response.message.isNotEmpty ? state.response.message : 'Đổi mật khẩu thành công'), backgroundColor: const Color(0xFF4CAF50)),
            );
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPasswordField(
                    label: 'Mật khẩu hiện tại',
                    controller: _currentController,
                    obscure: _obscureCurrent,
                    toggle: () => setState(() => _obscureCurrent = !_obscureCurrent),
                    validator: (v) => (v == null || v.isEmpty) ? 'Vui lòng nhập mật khẩu hiện tại' : null,
                  ),
                  const SizedBox(height: 16),
                  _buildPasswordField(
                    label: 'Mật khẩu mới',
                    controller: _newController,
                    obscure: _obscureNew,
                    toggle: () => setState(() => _obscureNew = !_obscureNew),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Vui lòng nhập mật khẩu mới';
                      if (v.length < 6) return 'Ít nhất 6 ký tự';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildPasswordField(
                    label: 'Xác nhận mật khẩu mới',
                    controller: _confirmController,
                    obscure: _obscureConfirm,
                    toggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Vui lòng xác nhận mật khẩu mới';
                      if (v != _newController.text) return 'Mật khẩu không khớp';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state is ChangePasswordLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF202328),
                        foregroundColor: const Color(0xFFB0F847),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: Color(0xFFB0F847), width: 1.2)),
                      ),
                      child: state is ChangePasswordLoading
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFB0F847)))
                          : const Text('Đổi mật khẩu', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPasswordField({required String label, required TextEditingController controller, required bool obscure, required VoidCallback toggle, String? Function(String?)? validator}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF202328))),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          validator: validator,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 1.5)),
            suffixIcon: IconButton(
              icon: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: const Color(0xFF4CAF50)),
              onPressed: toggle,
            ),
          ),
        ),
      ],
    );
  }
}
