import 'package:college_management_app/Notification/notification.dart';
import 'package:college_management_app/Userprofile/profile.dart';
import 'package:college_management_app/uploadtoapi/uploadapi.dart';
import 'package:college_management_app/widgets/calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import'package:college_management_app/login_UI_yt/logintry.dart';
import'package:college_management_app/navigation_menu/navigation_bar.dart';
import 'package:lottie/lottie.dart';
import 'Attendance/attendancepercent.dart';
import 'Search/searching.dart';
import 'login_UI_yt/signup.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options:const FirebaseOptions( apiKey: 'AIzaSyDVZBV6gXfOFtvuh21hxi9yVgShl_ZL2Qg',
        appId: '1:854814242691:android:1003ed0a03987b99b5a8b6', messagingSenderId: 'messagingSenderId',
        projectId:'collegemanagementappacem'
         ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {


    return MaterialApp(

      debugShowCheckedModeBanner: false,
      title: 'College  Management System',
      initialRoute: '/home',
      routes: {
        '/': (context)=>  SignUpPage(),
        '/first': (context)=>  const Calendar(),
        '/second' : (context)=>const Notifications(),
        '/third': (context) =>const Search(),
    '/fourth': (context)=> Profile1(user: FirebaseAuth.instance.currentUser!,),
        '/sixth':(context)=> NavigationMenu(),
        '/seventh':(context)=> MyApp1(),
        '/eighth':(context)=>LoginPage(),
        '/ninth':(context)=>AttendanceScreen(),
        '/home':(context)=>SplashScreen(),
      },
      theme: ThemeData(
          backgroundColor: Colors.white,
        primarySwatch: Colors.blue,
// fontFamily: 'Inter',
   textTheme: GoogleFonts.salsaTextTheme(),
      ),

    );
  }
}
class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        AnimatedSplashScreen(
          splash:SizedBox.expand(
            child: Lottie.asset('animations/reading.json',
              repeat: true,
              reverse: true,
              animate: true,
              fit: BoxFit.cover,
            ),
          ),
          nextScreen: LoginPage(),
         // nextScreen: NavigationMenu(),
          splashTransition: SplashTransition.fadeTransition,
          duration: 3000,

        ),
         Positioned(
          top: MediaQuery.of(context).size.height * 0.2,
          right: MediaQuery.of(context).size.width * 0.3,
          child:  const CircleAvatar(
            radius: 70,
            backgroundImage: AssetImage('svgimage/img.png'),
          ),
        ),
        const SizedBox(height: 10,),
         const Center(
          child: Text('Bridging Ideas, Building Engineers ',style: TextStyle(
                    color:Colors.green,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
            decoration: TextDecoration.none,

                  ),


                  ),
        ),
        SizedBox(height: 10,),

      ],
    );
  }
}


