import 'package:flutter/material.dart';
import '../widgets/hacker_background.dart';
import '../widgets/matrix_rain.dart';
import '../widgets/terminal_text.dart';
import '../core/utils/sound_manager.dart';
import 'main_screen.dart';

class LauncherScreen extends StatefulWidget {
  const LauncherScreen({super.key});

  @override
  _LauncherScreenState createState() => _LauncherScreenState();
}

class _LauncherScreenState extends State<LauncherScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<String> _bootMessages = [
    'INITIALIZING PROXIMATE...',
    'LOADING BLUETOOTH PROTOCOLS...',
    'SYNCING FIREBASE DATABASE...',
    'INITIALIZING AI MATCHING ENGINE...',
    'CALIBRATING PROXIMITY SENSORS...',
    'ESTABLISHING SECURE CONNECTIONS...',
    'SYSTEM READY...',
  ];
  int _currentMessage = 0;
  bool _showButton = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _startBootSequence();
  }

  void _startBootSequence() async {
    for (int i = 0; i < _bootMessages.length; i++) {
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() => _currentMessage = i);
    }

    await Future.delayed(const Duration(seconds: 1));
    // Play a single startup/opening sound when the system is ready
    await SoundManager.playStartup();
    setState(() => _showButton = true);
    _controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Matrix Rain Background
          const MatrixRainWidget(),
          
          // Hacker Background Effects
          const HackerBackground(),
          
          // Main Content
          Center(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 2),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.5),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.8,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated Logo - replaced with loading indicator
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Rotating circle border
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.green.withOpacity(0.8),
                              ),
                            ),
                          ),
                          // Center icon
                          Icon(
                            Icons.terminal,
                            size: 60,
                            color: Colors.green,
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Terminal Boot Messages
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(color: Colors.green),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (int i = 0; i <= _currentMessage; i++)
                              TerminalText(
                                text: _bootMessages[i],
                                speed: 20,
                                color: i == _currentMessage ? Colors.green : Colors.green.withOpacity(0.7),
                              ),
                            if (_currentMessage == _bootMessages.length - 1)
                              const SizedBox(height: 10),
                            if (_currentMessage == _bootMessages.length - 1)
                              AnimatedBuilder(
                                animation: _controller,
                                builder: (context, child) {
                                  return Opacity(
                                    opacity: _controller.value,
                                    child: const TerminalText(
                                      text: '>> SYSTEM READY <<',
                                      speed: 0,
                                      color: Colors.green,
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Launch Button
                    if (_showButton)
                      ScaleTransition(
                        scale: Tween(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                            parent: _controller,
                            curve: Curves.elasticOut,
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MainScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            side: const BorderSide(color: Colors.green, width: 2),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 20,
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.rocket_launch, color: Colors.green),
                              SizedBox(width: 10),
                              Text(
                                'LAUNCH APP',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Monospace',
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          
          // Footer
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'PROXIMATE v1.0 | © 2024 HACKER NETWORK',
                style: TextStyle(
                  fontFamily: 'Monospace',
                  color: Colors.green.withOpacity(0.5),
                  fontSize: 12,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}