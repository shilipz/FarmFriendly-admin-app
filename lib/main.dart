import 'package:cucumber_admin/presentation/presentation_logic/bloc/login/login_bloc.dart';
import 'package:cucumber_admin/presentation/presentation_logic/bloc/quantity_button/quantity_button_bloc.dart';
import 'package:cucumber_admin/presentation/presentation_logic/bloc/signup/signup_bloc.dart';
import 'package:cucumber_admin/presentation/views/signing.dart/splash_screen.dart';
import 'package:cucumber_admin/utils/screen_size.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

final screenWidth = ScreenSize.screenWidth;
final screenHeight = ScreenSize.screenHeight;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SignupBloc(),
        ),
        BlocProvider(
          create: (context) => LoginBloc(),
        ),
        BlocProvider(
          create: (context) => QuantityButtonBloc(),
        )
      ],
      child: MaterialApp(
        theme: ThemeData.light(),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
