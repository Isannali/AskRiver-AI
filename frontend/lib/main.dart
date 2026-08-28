import "package:flutter/material.dart";
import "package:provider/provider.dart";
import 'package:flutter_dotenv/flutter_dotenv.dart';

import "pages/chat_page.dart";
import "providers/chat_provider.dart";
import "theme/app_theme.dart";

Future <void>  main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ChatProvider(),
        ),
      ],
      child: const AskRiverApp(),
    ),
  );
}

class AskRiverApp extends StatelessWidget {
  const AskRiverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "AskRiver AI",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const ChatPage(),
    );
  }
}