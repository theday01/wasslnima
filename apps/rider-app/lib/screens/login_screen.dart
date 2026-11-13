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

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _handleSendOtp() {
    if (_phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء إدخال رقم الهاتف المغربي'),
          backgroundColor: WasslniColors.error,
        ),
      );
      return;
    }
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isOtpSent = true;
        });
      }
    });
  }

  void _handleVerifyOtp() {
    if (_otpController.text.trim().length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء إدخال رمز التحقق المكون من 4 إلى 6 أرقام'),
          backgroundColor: WasslniColors.error,
        ),
      );
      return;
    }
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeMapScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WasslniColors.lightCanvas,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('اللغات المدعومة: الدارجة المغربية، العربية، الفرنسية، الأمازيغية')),
              );
            },
            icon: const Icon(Icons.language, color: WasslniColors.emerald800, size: 18),
            label: const Text(
              'الدارجة المغربية',
              style: TextStyle(color: WasslniColors.emerald800, fontSize: 13, fontWeight: FontWeight.w700),
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
                  color: WasslniColors.lightTextPrimary,
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
                  color: WasslniColors.lightTextSecondary,
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
                    icon: const Icon(Icons.chat_outlined, color: Color(0xFF25D366), size: 20),
                    label: const Text(
                      'التوصل بالرمز عبر واتساب بدلاً من SMS',
                      style: TextStyle(
                        color: Color(0xFF1E7E34),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ] else ...[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: WasslniColors.lightBorder, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: WasslniColors.emerald800,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 10,
                    ),
                    decoration: const InputDecoration(
                      hintText: '• • • • • •',
                      hintStyle: TextStyle(
                        color: WasslniColors.lightTextTertiary,
                        letterSpacing: 8,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                WasslniButton(
                  text: 'تأكيد ودخول التطبيق',
                  isLoading: _isLoading,
                  onPressed: _handleVerifyOtp,
                ),
                const SizedBox(height: 14),
                Center(
                  child: TextButton(
                    onPressed: () {
                      setState(() => _isOtpSent = false);
                    },
                    child: const Text(
                      'تعديل رقم الهاتف',
                      style: TextStyle(
                        color: WasslniColors.lightTextSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],

              const Spacer(),

              // CNDP Privacy assurance
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.lock_outline, color: WasslniColors.lightTextTertiary, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      'بياناتك محمية وفق قانون 09-08 واللجنة الوطنية CNDP',
                      style: TextStyle(
                        color: WasslniColors.lightTextTertiary.withOpacity(0.8),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
