import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/config/app_env.dart';
import 'core/storage/local_storage_service.dart';
import 'core/theme/app_theme.dart';
import 'features/users/presentation/bloc/user_bloc.dart';
import 'features/users/presentation/pages/user_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set environment (bisa diganti via build flavor)
  AppEnv.setEnvironment(Environment.development);

  // Initialize local storage
  await LocalStorageService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Provide UserBloc
        BlocProvider<UserBloc>(create: (context) => UserBloc()),
        // Tambahkan BLoC lain di sini jika diperlukan
      ],
      child: MaterialApp(
        title: 'BLoC Demo',
        debugShowCheckedModeBanner: false,

        // Gunakan AppTheme dari theme system
        theme: AppTheme.darkTheme,

        // Chucker Navigator Observer untuk monitoring HTTP requests
        // Shake device atau tap notification untuk melihat requests
        navigatorObservers: [ChuckerFlutter.navigatorObserver],

        // Home page
        home: const UserPage(),
      ),
    );
  }
}
