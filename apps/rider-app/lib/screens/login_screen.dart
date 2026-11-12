import 'package:flutter/material.dart';
import 'package:flutter_ui/flutter_ui.dart';
import 'home_map_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _isOtpSent = false;
  bool _isLoading = false;

  void _handleSendOtp() {
    if (_phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إدخال رقم الهاتف المغربي')),
      );
      return;
    }
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 900), () {
      setState(() {
        _isLoading = false;
        _isOtpSent = true;
      });
    });
  }

  void _handleVerifyOtp() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 900), () {
      setState(() => _isLoading = false);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeMapScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WasslniColors.darkCanvas,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.language, color: WasslniColors.gold500, size: 18),
            label: const Text(
              'الدارجة المغربية',
              style: TextStyle(color: WasslniColors.gold500, fontSize: 13),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                _isOtpSent ? 'تحقق من رمز التأكيد' : 'تسجيل الدخول',
                style: const TextStyle(
                  color: WasslniColors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _isOtpSent
                  ? 'أدخل الرمز المكون من 6 أرقام المرسل إلى هاتفك'
                  : 'أدخل رقم هاتفك المغربي للمتابعة بدون كلمة سر',
                style: const TextStyle(
                  color: WasslniColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 32),

              if (!_isOtpSent) ...[
                MoroccanPhoneField(controller: _phoneController),
                const SizedBox(height: 24),
                WasslniButton(
                  text: 'إرسال رمز التحقق',
                  isLoading: _isLoading,
                  onPressed: _handleSendOtp,
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton.icon(
                    onPressed: _handleSendOtp,
                    icon: const Icon(Icons.chat, color: Color(0xFF25D366), size: 20),
                    label: const Text(
                      'التوصل بالرمز عبر واتساب بدلاً من SMS',
                      style: TextStyle(color: Color(0xFF25D366), fontSize: 13),
                    ),
                  ),
                ),
              ] else ...[
                Container(
                  decoration: BoxDecoration(
                    color: WasslniColors.darkSurface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: WasslniColors.darkBorder),
                  ),
                  child: TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: WasslniColors.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 14,
                    ),
                    decoration: const InputDecoration(
                      hintText: '000000',
                      hintStyle: TextStyle(
                        color: WasslniColors.textTertiary,
                        letterSpacing: 14,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                WasslniButton(
                  text: 'تأكيد ودخول',
                  isLoading: _isLoading,
                  onPressed: _handleVerifyOtp,
                ),
                const SizedBox(height: 12),
                Center(
                  child: TextButton(
                    onPressed: () => setState(() => _isOtpSent = false),
                    child: const Text(
                      'تغيير رقم الهاتف',
                      style: TextStyle(color: WasslniColors.textSecondary),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

