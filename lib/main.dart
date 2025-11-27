// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'screens/home_screen.dart';
// import 'screens/notes_screen.dart';
// import 'package:provider/provider.dart';
// import 'providers/auth_provider.dart';
// import 'screens/auth_screen.dart';


// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AuthProvider()),
//         // Add other providers as needed
//       ],
//       child: MaterialApp(
//         title: 'Notes App',
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//           useMaterial3: true,
//         ),
//         initialRoute: '/auth',
//         routes: {
//           '/auth': (context) => const AuthScreen(),
//           '/home': (context) => const HomeScreen(),
//           '/notes': (context) => const NotesScreen(),
//         },
//       ),
//     );
//   }
// }



// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'navigation/auth_navigator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // Add other providers here
      ],
      child: const AuthNavigator(),
    );
  }
}