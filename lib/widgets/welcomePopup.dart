import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomePopup {
  static Future<void> showIfFirstTime(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final hasShownPopup = prefs.getBool('hasShownWelcomePopup') ?? false;

    if (!hasShownPopup) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const _WelcomeDialog(),
      );
      await prefs.setBool('hasShownWelcomePopup', true);
    }
  }
}

class _WelcomeDialog extends StatelessWidget {
  const _WelcomeDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.all(16),
      content: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6, // giới hạn chiều cao tối đa
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animation
              Lottie.asset(
                'assets/welcome.json',
                width: 150,
                height: 150,
                repeat: true,
              ),

              const SizedBox(height: 12),

              // Cảm ơn
              Text(
                'Cảm ơn bạn đã tải ứng dụng! CHÚC BẠN MỘT NGÀY TỐT LÀNH',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              // Hai nút
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Đóng'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(context, '/about', (route) => false);
                    },
                    child: const Text('Hướng dẫn'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

