import 'package:flutter/material.dart';
import 'package:mischwaldscore/pages/homescreen.dart';
import 'package:mischwaldscore/provider/gameprovider.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: <ChangeNotifierProvider<ChangeNotifier>>[
        // ChangeNotifierProvider<SharedPrefsProvider>(create: (BuildContext context) => sharedPrefsProvider),
        ChangeNotifierProvider<GameProvider>(create: (BuildContext context) => GameProvider()),
      ],
      child: const MyApp()
    ),
  );

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}