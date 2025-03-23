import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:jsonuiapp/blocs/auth_bloc/auth_bloc.dart';
import 'package:jsonuiapp/blocs/ui_bloc/ui_bloc.dart';
import 'package:jsonuiapp/main.dart';
import 'package:jsonuiapp/screens/otp_screen.dart';
import 'package:jsonuiapp/ui_widgets/button_widget.dart';
import 'package:jsonuiapp/ui_widgets/image_widget.dart';
import 'package:jsonuiapp/ui_widgets/text_field_widget.dart';
import 'package:jsonuiapp/ui_widgets/text_widget.dart';

class DynamicUIScreen extends StatefulWidget {
  final String screenName;

  const DynamicUIScreen({super.key, required this.screenName});

  @override
  _DynamicUIScreenState createState() => _DynamicUIScreenState();
}

class _DynamicUIScreenState extends State<DynamicUIScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final ValueNotifier<bool> _isDarkMode = ValueNotifier<bool>(false);
  final bool _isOtpSent = false;
  final TextEditingController _otpController = TextEditingController();
  List<Map<String, dynamic>> _bottomNavItems = [];
  final ValueNotifier<int> _selectedIndex = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UIBloc, UIState>(
      builder: (context, state) {
        _isDarkMode.value = state.isDarkMode;
        if (state.isLoading ?? true) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.uiConfig == null) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, color: Colors.red, size: 50),
                SizedBox(height: 10),
                Text("Failed to load UI. Please try again."),
              ],
            ),
          );
        }
        var screen =
            state.uiConfig?["screens"]?.firstWhere(
              (s) => s["name"] == widget.screenName,
              orElse: () => {},
            ) ??
            {};

        if (screen.isEmpty) {
          return const Center(child: Text("Screen not found"));
        }

        if (screen.containsKey("bottom_nav")) {
          _bottomNavItems = List<Map<String, dynamic>>.from(
            screen["bottom_nav"],
          );
        } else {
          _bottomNavItems = [];
        }

        List<Widget> widgets =
            (screen["widgets"] as List<dynamic>?)
                ?.map<Widget>((widget) => _buildWidget(context, widget))
                .toList() ??
            [];

        return Scaffold(
          appBar: AppBar(
            title: Text(screen["name"].toUpperCase()),
            automaticallyImplyLeading: false, // Hide back button
          ),
          body:
              screen.containsKey("bottom_nav") && screen["bottom_nav"] != null
                  ? ValueListenableBuilder<int>(
                    valueListenable: _selectedIndex,
                    builder: (context, index, child) {
                      return IndexedStack(
                        index: index,
                        children:
                            screen["bottom_nav"].map<Widget>((navItem) {
                              return _buildScreen(
                                context,
                                navItem["screen"],
                                state,
                              );
                            }).toList(),
                      );
                    },
                  )
                  : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: widgets,
                      ),
                    ),
                  ),
          bottomNavigationBar: _buildBottomNavigation(context, state, screen),
        );
      },
    );
  }

  Widget _buildScreen(BuildContext context, String screenName, UIState state) {
    var screen = state.uiConfig!["screens"].firstWhere(
      (s) => s["name"] == screenName,
      orElse: () => <String, dynamic>{},
    );

    if (screen == null) {
      return const Center(child: Text("Screen not found"));
    }

    List<Widget> widgets =
        screen["widgets"]?.map<Widget>((widget) {
          return _buildWidget(context, widget);
        })?.toList() ??
        [];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: widgets,
        ),
      ),
    );
  }

  Widget? _buildBottomNavigation(
    BuildContext context,
    UIState state,
    Map<String, dynamic> screen,
  ) {
    if (screen["bottom_nav"] == null) return null;

    return ValueListenableBuilder<int>(
      valueListenable: _selectedIndex,
      builder: (context, index, child) {
        return BottomNavigationBar(
          currentIndex: index,
          items:
              _bottomNavItems.map<BottomNavigationBarItem>((item) {
                return BottomNavigationBarItem(
                  icon: Icon(_getIconFromString(item["icon"])),
                  label: item["title"],
                );
              }).toList(),
          onTap: (newIndex) {
            _selectedIndex.value = newIndex;
          },
        );
      },
    );
  }

  Widget _buildWidget(BuildContext context, Map<String, dynamic> widget) {
    switch (widget["type"]) {
      case "text":
        return CustomTextWidget(widgetConfig: widget);

      case "textfield":
        return CustomTextFieldWidget(
          widgetConfig: widget,
          controller: _getController(widget["hint"] ?? ""),
        );

      case "button":
        return Column(
          children: [
            CustomButtonWidget(
              widgetConfig: widget,
              onPressed:
                  () => _handleButtonAction(
                    context,
                    widget["action"],
                    widget["target"],
                  ),
            ),
            Gap(10),
          ],
        );

      case "image":
        return CustomImageWidget(widgetConfig: widget);

      case "otp_input":
        if (_isOtpSent) {
          return Column(
            children: [
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: "Enter OTP"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  final authBloc = BlocProvider.of<AuthBloc>(context);
                  authBloc.add(HandleAuth(authType: "verify_otp"));
                },
                child: const Text("Verify OTP"),
              ),
            ],
          );
        }
        break;

      case "toggle":
        return ValueListenableBuilder<bool>(
          valueListenable: _isDarkMode,
          builder: (context, isDark, child) {
            return SwitchListTile(
              title: Text(widget["text"] ?? ""),
              value: isDark,
              onChanged: (val) {
                _isDarkMode.value = val;
                if (widget["action"] == "toggle_theme") {
                  context.read<UIBloc>().add(ToggleThemeEvent());
                }
              },
            );
          },
        );

      case "list":
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.containsKey("title"))
              Text(
                widget["title"],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget["items"]?.length ?? 0,
              itemBuilder: (context, index) {
                final item = widget["items"][index];
                return ListTile(
                  leading:
                      item.containsKey("icon")
                          ? Icon(_getIconFromString(item["icon"]))
                          : null,
                  title: Text(item["title"] ?? ""),
                  subtitle:
                      item.containsKey("subtitle")
                          ? Text(item["subtitle"])
                          : null,
                );
              },
            ),
          ],
        );

      case "grid":
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widget["columns"] ?? 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: widget["items"]?.length ?? 0,
          itemBuilder: (context, index) {
            final item = widget["items"][index];
            return GestureDetector(
              onTap:
                  () => _handleButtonAction(
                    context,
                    item["action"],
                    item["target"],
                  ),
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (item.containsKey("icon"))
                      Icon(_getIconFromString(item["icon"])),
                    const SizedBox(height: 5),
                    Text(item["title"] ?? ""),
                  ],
                ),
              ),
            );
          },
        );

      case "carousel":
        return SizedBox(
          height: 200,
          child: PageView.builder(
            itemCount: widget["items"]?.length ?? 0,
            itemBuilder: (context, index) {
              final item = widget["items"][index];
              return Image.network(item["image"], fit: BoxFit.cover);
            },
          ),
        );

      default:
        return const SizedBox.shrink();
    }
    return const SizedBox.shrink();
  }

  Color getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  IconData _getIconFromString(String iconName) {
    switch (iconName) {
      case "home":
        return Icons.home;
      case "person":
        return Icons.person;
      case "settings":
        return Icons.settings;
      case "star":
        return Icons.star;
      case "favorite":
        return Icons.favorite;
      case "check_circle":
        return Icons.check_circle;
      default:
        return Icons.help_outline; // Default icon
    }
  }

  TextEditingController _getController(String? hint) {
    if (hint == "Email" || hint == "Enter email") return _emailController;
    if (hint == "Full Name") return _nameController;
    return _passwordController;
  }

  void _handleButtonAction(
    BuildContext context,
    String action, [
    String? target,
  ]) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    switch (action) {
      case "google_auth":
        authBloc.add(HandleAuth(authType: "google_auth"));
        break;
      case "apple_auth":
        authBloc.add(HandleAuth(authType: "apple_auth"));
        break;
      case "firebase_login":
        if (email.isNotEmpty && password.isNotEmpty) {
          authBloc.add(
            HandleAuth(
              authType: "firebase_email_password",
              email: email,
              password: password,
            ),
          );
        } else {
          ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
            SnackBar(
              content: Text('Email and Password are required'),
              backgroundColor: Colors.red,
            ),
          );
        }
        break;
      case "firebase_signup":
        if (email.isNotEmpty && password.isNotEmpty) {
          authBloc.add(
            HandleAuth(
              authType: "firebase_signup",
              email: email,
              password: password,
            ),
          );
        }
        break;
      case "firebase_logout":
        authBloc.add(AuthLogout());
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DynamicUIScreen(screenName: "login"),
          ),
        );
        break;
      case "navigate":
        if (target != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DynamicUIScreen(screenName: target),
            ),
          );
        }
        break;
      case "back":
        if (target != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DynamicUIScreen(screenName: target),
            ),
          );
        }
        break;
      case "otp_login":
        if (target != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OTPScreen()),
          );
        }
        break;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
