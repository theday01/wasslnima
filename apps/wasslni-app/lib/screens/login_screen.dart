import 'package:flutter/material.dart';
import 'package:flutter_ui/flutter_ui.dart';
import 'role_selection_screen.dart';

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
          MaterialPageRoute(
            builder: (_) => RoleSelectionScreen(
              initialPhone: _phoneController.text.trim(),
            ),
          ),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: WasslniColors.emerald800,
                    shape: BoxShape.circle,
                    border: Border.all(color: WasslniColors.gold500, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: WasslniColors.emerald800.withOpacity(0.25),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.directions_car_filled_rounded,
                    color: WasslniColors.gold500,
                    size: 42,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'مرحباً بك في وصّلني 🇲🇦',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: WasslniColors.emerald800,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'التطبيق المغربي الموحد للركاب والسائقين',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: WasslniColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 36),

              // Step indicator
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: WasslniColors.emerald800,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: _isOtpSent ? WasslniColors.emerald800 : WasslniColors.lightBorder,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              if (!_isOtpSent) ...[
                const Text(
                  'رقم الهاتف المغربي',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: WasslniColors.emerald800,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: '06 12 34 56 78',
                    prefixIcon: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      margin: const EdgeInsets.only(left: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text('🇲🇦', style: TextStyle(fontSize: 18)),
                          SizedBox(width: 6),
                          Text(
                            '+212',
                            style: TextStyle(
                              color: WasslniColors.emerald800,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: WasslniColors.lightBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: WasslniColors.emerald800, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleSendOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: WasslniColors.emerald800,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          'إرسال رمز التحقق (SMS/WhatsApp) ➔',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                        ),
                ),
              ] else ...[
                const Text(
                  'أدخل رمز التحقق المكون من 4 أرقام',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: WasslniColors.emerald800,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 8,
                  ),
                  decoration: InputDecoration(
                    hintText: '• • • •',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: WasslniColors.lightBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: WasslniColors.emerald800, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleVerifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: WasslniColors.emerald800,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          'تأكيد الدخول واختيار نوع الحساب ➔',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
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

