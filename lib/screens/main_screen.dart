import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/hacker_background.dart';
import 'profile_setup.dart';
import 'nearby_people.dart';
import 'matches_screen.dart';
import 'chat_screen.dart';
import 'qr_share_screen.dart';
import 'team_formation_screen.dart';
import 'event_browser_screen.dart';
import 'encryption_setup_screen.dart';
import '../core/utils/sound_manager.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _glowController;

  final List<Widget> _screens = [
    const NearbyPeopleScreen(),
    const MatchesScreen(),
    const ChatScreen(),
    const QRShareScreen(),
    const TeamFormationScreen(),
    const EventBrowserScreen(),
    const ProfileSetupScreen(),
    const EncryptionSetupScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'PROXIMATE',
          style: TextStyle(
            fontFamily: 'Monospace',
            color: Colors.green,
            fontSize: 18,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.green),
            onPressed: () {
              _showSettingsMenu();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          const HackerBackground(),
          _screens[_selectedIndex],
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.9),
          border: const Border(
            top: BorderSide(color: Colors.green, width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.radar, 'Scan', 0),
            _buildNavItem(Icons.connected_tv, 'Matches', 1),
            _buildNavItem(Icons.chat, 'Chat', 2),
            _buildNavItem(Icons.qr_code, 'QR', 3),
            _buildNavItem(Icons.group, 'Teams', 4),
            _buildNavItem(Icons.event, 'Events', 5),
            _buildNavItem(Icons.person, 'Profile', 6),
          ],
        ),
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _glowController,
        builder: (context, child) {
          return Transform.scale(
            scale: 1 + _glowController.value * 0.1,
            child: FloatingActionButton(
              onPressed: () {
                _showQuickActions();
              },
              backgroundColor: Colors.black,
              child: const Icon(
                Icons.bolt,
                color: Colors.green,
                size: 30,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    
    return InkWell(
      onTap: () {
        setState(() => _selectedIndex = index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          border: isSelected
              ? const Border(
                  bottom: BorderSide(color: Colors.green, width: 3),
                )
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.green : Colors.green.withOpacity(0.5),
              size: 20,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Monospace',
                color: isSelected ? Colors.green : Colors.green.withOpacity(0.5),
                fontSize: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickActions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'QUICK ACTIONS',
                style: TextStyle(
                  fontFamily: 'Monospace',
                  color: Colors.green,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _buildQuickAction('Scan', Icons.radar, () {
                    Navigator.pop(context);
                    setState(() => _selectedIndex = 0);
                  }),
                  _buildQuickAction('QR Share', Icons.qr_code, () {
                    Navigator.pop(context);
                    setState(() => _selectedIndex = 3);
                  }),
                  _buildQuickAction('Find Team', Icons.group, () {
                    Navigator.pop(context);
                    setState(() => _selectedIndex = 4);
                  }),
                  _buildQuickAction('Encrypt', Icons.lock, () {
                    Navigator.pop(context);
                    setState(() => _selectedIndex = 7);
                  }),
                  _buildQuickAction('Events', Icons.event, () {
                    Navigator.pop(context);
                    setState(() => _selectedIndex = 5);
                  }),
                  _buildQuickAction('Profile', Icons.person, () {
                    Navigator.pop(context);
                    setState(() => _selectedIndex = 6);
                  }),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickAction(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        SoundManager.playNotification();
        onTap();
      },
      child: Container(
        width: 80,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(color: Colors.green),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.green, size: 24),
            const SizedBox(height: 5),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Monospace',
                color: Colors.green,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSettingsMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 50,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'SETTINGS',
                  style: TextStyle(
                    fontFamily: 'Monospace',
                    color: Colors.green,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildSettingItem('Encryption Settings', Icons.lock, () {
                  Navigator.pop(context);
                  this.setState(() => _selectedIndex = 7);
                }),
                ListTile(
                  onTap: () async {
                    await SoundManager.toggleMute();
                    setState(() {});
                  },
                  leading: const Icon(Icons.volume_up, color: Colors.green),
                  title: const Text(
                    'Sound Effects',
                    style: TextStyle(
                      fontFamily: 'Monospace',
                      color: Colors.green,
                    ),
                  ),
                  trailing: Switch(
                    value: !SoundManager.isMuted,
                    onChanged: (_) async {
                      await SoundManager.toggleMute();
                      setState(() {});
                    },
                    activeColor: Colors.green,
                  ),
                ),
                _buildSettingItem('Appearance', Icons.palette, () {
                  Get.snackbar(
                    'Info',
                    'Dark theme is enabled',
                    backgroundColor: Colors.black,
                    colorText: Colors.green,
                  );
                }),
                _buildSettingItem('Privacy', Icons.privacy_tip, () {
                  Get.snackbar(
                    'Info',
                    'Privacy policy: Your data stays local',
                    backgroundColor: Colors.black,
                    colorText: Colors.green,
                  );
                }),
                _buildSettingItem('About', Icons.info, () {
                  Navigator.pop(context);
                  showAboutDialog(
                    context: context,
                    applicationName: 'PROXIMATE',
                    applicationVersion: '1.0.0',
                    applicationLegalese: 'Proximate - Nearby connections',
                  );
                }),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: Colors.green),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Monospace',
          color: Colors.green,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.green),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }
}