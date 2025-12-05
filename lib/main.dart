import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'core/services/bluetooth_service.dart';
import 'core/services/encryption_service.dart';
import 'core/services/qr_service.dart';
import 'core/services/team_service.dart';
import 'core/utils/secure_storage.dart';
import 'core/utils/sound_manager.dart';
import 'screens/launcher_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  await SecureStorage.init();
  await SoundManager.init();
  await Get.putAsync(() => EncryptionService().init());
  await Get.putAsync(() => QRService().init());
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BluetoothService()),
        ChangeNotifierProvider(create: (_) => TeamService()),
        Provider(create: (_) => SecureStorage()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PROXIMATE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.green,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Monospace', color: Colors.green),
          bodyMedium: TextStyle(fontFamily: 'Monospace', color: Colors.green),
        ),
      ),
      home: const LauncherScreen(),
    );
  }
}