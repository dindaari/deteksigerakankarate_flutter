import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:motion_martial/pages/article.dart';
import 'package:motion_martial/pages/beranda.dart';
import 'package:motion_martial/pages/changeemail.dart';
import 'package:motion_martial/pages/changepassword.dart';
import 'package:motion_martial/pages/chatbot.dart';
import 'package:motion_martial/pages/deteksi_screen.dart';
import 'package:motion_martial/pages/editeprofile.dart';
// import 'package:motion_martial/pages/verifikasi.dart';
import 'package:motion_martial/pages/forgotpassword.dart';
import 'package:motion_martial/pages/profile_screen.dart';
import 'package:motion_martial/pages/signin.dart';
import 'package:motion_martial/pages/signup.dart';
// import 'package:motion_martial/pages/splash_screen_2.dart';

List<CameraDescription>? cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Motion Martial',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/signin',
      routes: {
        // '/': (context) => SplashScreen2(),
        '/signin': (context) => Signin(),
        '/signup': (context) => Signup(),
        '/beranda': (context) => Beranda(),
        '/chatbot': (context) => Chatbot(),
        '/deteksi': (context) => DeteksiScreen(),
        '/profile': (context) => ProfileScreen(),
        '/verifikasi': (context) => Verifikasi(),
        '/article': (context) => Article(),
        '/forgotpassword': (context) => ForgotPassword(),
        '/changepassword': (context) => ChangePassword(),
        '/changeemail': (context) => ChangeEmail(),
        '/editeprofile': (context) => EditProfile(),
      },
    );
  }
}
