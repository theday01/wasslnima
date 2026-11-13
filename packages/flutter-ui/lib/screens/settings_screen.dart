import 'package:flutter/material.dart';
import '../wasslni_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _soundEnabled = true;
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'العربية (المغربية)';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WasslniColors.lightCanvas,
      appBar: AppBar(
        title: const Text('إعدادات التطبيق', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // General Settings Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: WasslniColors.lightBorder),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: const Text('لغة التطبيق', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: Text(_selectedLanguage, style: const TextStyle(color: WasslniColors.emerald800, fontSize: 12)),
                    leading: const Icon(Icons.language, color: WasslniColors.emerald800),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                    onTap: () {
                      _showLanguageDialog();
                    },
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('التنبيهات الصوتية', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: const Text('صوت عند تلقي عرض جديد أو اقتراب السائق', style: TextStyle(fontSize: 12)),
                    secondary: const Icon(Icons.volume_up_outlined, color: WasslniColors.emerald800),
                    value: _soundEnabled,
                    activeColor: WasslniColors.emerald800,
                    onChanged: (val) => setState(() => _soundEnabled = val),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('إشعارات الهاتف', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: const Text('إرسال التنبيهات حتى عند قفل الشاشة', style: TextStyle(fontSize: 12)),
                    secondary: const Icon(Icons.notifications_active_outlined, color: WasslniColors.emerald800),
                    value: _notificationsEnabled,
                    activeColor: WasslniColors.emerald800,
                    onChanged: (val) => setState(() => _notificationsEnabled = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Legal & About Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: WasslniColors.lightBorder),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: const Text('شروط الاستخدام والسياسة القانونية', style: TextStyle(fontSize: 14)),
                    leading: const Icon(Icons.description_outlined, color: WasslniColors.lightTextSecondary),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: const Text('عن وصّلني المغرب', style: TextStyle(fontSize: 14)),
                    subtitle: const Text('الإصدار v1.0.0 (الدار البيضاء)', style: TextStyle(fontSize: 12)),
                    leading: const Icon(Icons.info_outline, color: WasslniColors.lightTextSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('اختر اللغة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('العربية (المغربية)'),
              value: 'العربية (المغربية)',
              groupValue: _selectedLanguage,
              onChanged: (val) {
                setState(() => _selectedLanguage = val!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Français (Maroc)'),
              value: 'Français (Maroc)',
              groupValue: _selectedLanguage,
              onChanged: (val) {
                setState(() => _selectedLanguage = val!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Tamazight (الدارجة/الأمازيغية)'),
              value: 'Tamazight',
              groupValue: _selectedLanguage,
              onChanged: (val) {
                setState(() => _selectedLanguage = val!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
