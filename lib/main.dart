import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_sample/page/user_page.dart';
import 'package:shared_sample/utils/user_simple_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 画面の向きを設定
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // ユーザーの簡易設定を初期化
  await UserSimplePreferences.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Shared Preferences Demo",
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        home: const UserPage(),
      );
}
