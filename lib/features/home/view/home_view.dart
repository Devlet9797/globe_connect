import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../features/auth/viewmodel/auth_view_model.dart';
import 'widgets/custom_navigation_bar.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1B1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1B1E),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(
                'Re',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Tüm Ülkeler',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              final viewModel = context.read<AuthViewModel>();
              await viewModel.signOut();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildTabButton('Makaleler', 0),
                      const SizedBox(width: 16),
                      _buildTabButton('Mikroblog', 1),
                      const SizedBox(width: 16),
                      _buildTabButton('İş İlanları', 2),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildArticleCard(
                    'Topografik Kretinizm Nedir ve Nasıl Üstesinden Gelinir',
                    'Bilgisayar oyunları bile yön bulma becerilerini geliştirmek için yardımcı olabilir',
                    '5',
                    '2',
                    '22',
                  ),
                  const SizedBox(height: 16),
                  _buildArticleCard(
                    'ETIAS Sisteminin Avrupa Birliğinde Uygulanması 2026\'ya Ertelendi',
                    'Avrupa Birliği, ETIAS sisteminin uygulanmasını tekrar erteledi...',
                    '5',
                    '0',
                    '135',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildTabButton(String text, int index) {
    bool isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildArticleCard(
    String title,
    String subtitle,
    String likes,
    String comments,
    String views,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF242529),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.favorite_border, color: Colors.white, size: 20),
                const SizedBox(width: 4),
                Text(likes, style: TextStyle(color: Colors.white)),
                const SizedBox(width: 16),
                Icon(Icons.chat_bubble_outline, color: Colors.white, size: 20),
                const SizedBox(width: 4),
                Text(comments, style: TextStyle(color: Colors.white)),
                const Spacer(),
                Icon(Icons.remove_red_eye_outlined,
                    color: Colors.white, size: 20),
                const SizedBox(width: 4),
                Text(views, style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
