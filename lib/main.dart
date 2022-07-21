import 'package:doki/screens/viewer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemStatusBarContrastEnforced: false,
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);
  setup();
  runApp(MaterialApp(
    theme: ThemeData(useMaterial3: true, fontFamily: 'Manrope'),
    debugShowCheckedModeBanner: false,
    home: const ViewerScreen(),
  ));
}
