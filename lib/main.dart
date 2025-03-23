import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jsonuiapp/blocs/auth_bloc/auth_bloc.dart';
import 'package:jsonuiapp/blocs/ui_bloc/ui_bloc.dart';
import 'package:jsonuiapp/service_injector.dart';
import 'package:jsonuiapp/utils/app_routes.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<UIBloc>()..add(LoadUiEvent())),
        BlocProvider(create: (context) => sl<AuthBloc>()),
      ],
      child: Builder(
        builder: (context) {
          return BlocBuilder<UIBloc, UIState>(
            builder: (context, state) {
              return MaterialApp(
                title: 'JSON UI APP',
                debugShowCheckedModeBanner: false,
                theme: _buildTheme(state.isDarkMode),
                navigatorKey: navigatorKey,
                initialRoute: AppRoutes.login,
                onGenerateRoute:
                    (settings) => AppRoutes.generateRoute(settings),
                builder: (context, child) {
                  return BlocListener<AuthBloc, AuthState>(
                    listenWhen:
                        (previous, current) =>
                            previous.user != current.user ||
                            previous.errorMessage != current.errorMessage,
                    listener: (context, state) {
                      if (state.user != null) {
                        navigatorKey.currentState?.pushNamedAndRemoveUntil(
                          AppRoutes.dashboard,
                          (route) => false,
                        );
                      } else if (state.errorMessage?.isNotEmpty ?? false) {
                        final currentContext = navigatorKey.currentContext;
                        if (currentContext != null) {
                          ScaffoldMessenger.of(currentContext).showSnackBar(
                            SnackBar(
                              content: Text(state.errorMessage!),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    child: child!,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  ThemeData _buildTheme(bool isDarkMode) {
    return ThemeData(
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      primaryColor: isDarkMode ? Colors.blueGrey : Colors.deepOrange,
      scaffoldBackgroundColor: isDarkMode ? Colors.black : Colors.white,
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
      ),
    );
  }
}
