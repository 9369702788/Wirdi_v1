import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('وردي'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'مساء الخير 👋',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),

          const Text(
            'واصل ما بدأته اليوم',
            style: TextStyle(color: AppColors.mutedText),
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppColors.primaryEmerald,
                  Color(0xFF115E56),
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الصلاة القادمة',
                  style: TextStyle(color: Colors.white70),
                ),
                SizedBox(height: 8),
                Text(
                  'العصر',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'بعد 01:42:10',
                  style: TextStyle(
                    color: AppColors.goldAccent,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          _DashboardCard(
            icon: Icons.donut_large,
            title: 'الورد اليومي',
            subtitle: 'ابدأ وردك اليومي الآن',
            trailing: const _MiniProgress(value: 0.0),
          ),

          const SizedBox(height: 12),

          const _DashboardCard(
            icon: Icons.bookmark_outline,
            title: 'متابعة القراءة',
            subtitle: 'لم يتم تحديد آخر قراءة بعد',
            trailing: Icon(
              Icons.chevron_left,
              color: AppColors.mutedText,
            ),
          ),

          const SizedBox(height: 12),

          const _DashboardCard(
            icon: Icons.favorite_outline,
            title: 'ذكر اليوم',
            subtitle: 'سبحان الله وبحمده',
            trailing: Icon(
              Icons.chevron_left,
              color: AppColors.mutedText,
            ),
          ),

          const SizedBox(height: 12),

          const _DashboardCard(
            icon: Icons.menu_book_outlined,
            title: 'اقتراح اليوم',
            subtitle: 'اقرأ سورة الملك قبل النوم',
            trailing: Icon(
              Icons.chevron_left,
              color: AppColors.mutedText,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;

  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: AppColors.primaryEmerald.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: AppColors.primaryEmerald,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.mutedText,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}

class _MiniProgress extends StatelessWidget {
  final double value;

  const _MiniProgress({
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 44,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: value,
            strokeWidth: 4,
            backgroundColor:
                AppColors.primaryEmerald.withOpacity(0.12),
            valueColor: const AlwaysStoppedAnimation(
              AppColors.goldAccent,
            ),
          ),
          Text(
            '${(value * 100).round()}%',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
