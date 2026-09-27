// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart'; 
import 'package:go_router/go_router.dart'; 
 
// Simulated authentication service 
class AuthService extends ChangeNotifier { 
  bool _loggedIn = false; 
 
  bool get loggedIn => _loggedIn; 
 
  void login() { 
    _loggedIn = true; 
    notifyListeners(); 
  } 
 
  void logout() { 
    _loggedIn = false; 
    notifyListeners(); 
  } 
} 
 
void main() { 
  final authService = AuthService(); 
 
  // Configure GoRouter with redirection logic 
  final router = GoRouter( 
    refreshListenable: authService, // Re-run redirect when auth changes 
    redirect: (context, state) { 
      final loggedIn = authService.loggedIn; 
      final loggingIn = state.matchedLocation == '/login'; 
 
      // If not logged in, redirect to /login 
      if (!loggedIn && !loggingIn) return '/login'; 
 
      // If logged in and trying to go to login, redirect to home 
      if (loggedIn && loggingIn) return '/'; 
 
      // No redirection 
      return null; 
    }, 
    routes: [ 
      GoRoute( 
        path: '/', 
        builder: (context, state) => HomeScreen(authService: authService), 
      ), 
      GoRoute( 
        path: '/login', 
        builder: (context, state) => LoginScreen(authService: authService), 
      ), 
    ], 
  ); 
 
  runApp(MyApp(router: router)); 
} 
 
class MyApp extends StatelessWidget { 
  final GoRouter router; 
  const MyApp({Key? key, required this.router}) : super(key: key); 
 
  @override 
  Widget build(BuildContext context) { 
    return MaterialApp.router( 
      title: 'Flutter Redirection Example', 
      routerConfig: router, 
    ); 
  } 
} 
 
// Home Screen 
class HomeScreen extends StatelessWidget { 
  final AuthService authService; 
  const HomeScreen({Key? key, required this.authService}) : super(key: key); 
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      appBar: AppBar(title: const Text('Home')), 
      body: Center( 
        child: ElevatedButton( 
          onPressed: () { 
            authService.logout(); 
          }, 
          child: const Text('Logout'), 
        ), 
      ), 
    ); 
  } 
} 
 
// Login Screen 
class LoginScreen extends StatelessWidget { 
  final AuthService authService; 
  const LoginScreen({Key? key, required this.authService}) : super(key: key); 
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      appBar: AppBar(title: const Text('Login')), 
      body: Center( 
        child: ElevatedButton( 
          onPressed: () { 
            authService.login(); 
          }, 
          child: const Text('Login'), 
        ), 
      ), 
    ); 
  } 
}