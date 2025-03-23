import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:jsonuiapp/blocs/auth_bloc/auth_bloc.dart';
import 'package:jsonuiapp/blocs/ui_bloc/ui_bloc.dart';
import 'package:jsonuiapp/screens/dynamic_ui_screen.dart';

@GenerateMocks([UIBloc, AuthBloc])
import 'dynamic_ui_screen_test.mocks.dart';

void main() {
  late MockUIBloc mockUIBloc;
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockUIBloc = MockUIBloc();
    mockAuthBloc = MockAuthBloc();
    when(mockAuthBloc.state).thenReturn(AuthState());
    when(mockAuthBloc.stream).thenAnswer((_) => Stream<AuthState>.empty());
  });

  Widget createTestWidget(String screenName) {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<UIBloc>.value(value: mockUIBloc),
          BlocProvider<AuthBloc>.value(value: mockAuthBloc),
        ],
        child: DynamicUIScreen(screenName: screenName),
      ),
    );
  }

  testWidgets('Displays loading indicator when UI is loading', (
    WidgetTester tester,
  ) async {
    when(mockUIBloc.state).thenReturn(UIState(isLoading: true));
    when(
      mockUIBloc.stream,
    ).thenAnswer((_) => Stream.value(UIState(isLoading: true)));

    await tester.pumpWidget(createTestWidget("home"));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Displays error message when UI config is null', (
    WidgetTester tester,
  ) async {
    when(
      mockUIBloc.state,
    ).thenReturn(UIState(isLoading: false, uiConfig: null));
    when(mockUIBloc.stream).thenAnswer(
      (_) => Stream.value(UIState(isLoading: false, uiConfig: null)),
    );

    await tester.pumpWidget(createTestWidget("home"));

    expect(find.text("Error loading UI"), findsOneWidget);
  });

  testWidgets('Displays screen not found message if screen does not exist', (
    WidgetTester tester,
  ) async {
    when(
      mockUIBloc.state,
    ).thenReturn(UIState(isLoading: false, uiConfig: {"screens": []}));
    when(mockUIBloc.stream).thenAnswer(
      (_) => Stream.value(UIState(isLoading: false, uiConfig: {"screens": []})),
    );

    await tester.pumpWidget(createTestWidget("unknown_screen"));

    expect(find.text("Screen not found"), findsOneWidget);
  });

  testWidgets('Renders widgets dynamically from JSON config', (
    WidgetTester tester,
  ) async {
    final uiConfig = {
      "screens": [
        {
          "name": "home",
          "widgets": [
            {"type": "text", "value": "Welcome Home!"},
            {
              "type": "button",
              "text": "Click Me",
              "action": "navigate",
              "target": "login",
            },
          ],
        },
      ],
    };

    when(
      mockUIBloc.state,
    ).thenReturn(UIState(isLoading: false, uiConfig: uiConfig));
    when(mockUIBloc.stream).thenAnswer(
      (_) => Stream.value(UIState(isLoading: false, uiConfig: uiConfig)),
    );

    await tester.pumpWidget(createTestWidget("home"));

    expect(find.text("Welcome Home!"), findsOneWidget);
    expect(find.text("Click Me"), findsOneWidget);
  });

  testWidgets('Handles button tap actions', (WidgetTester tester) async {
    final uiConfig = {
      "screens": [
        {
          "name": "home",
          "widgets": [
            {
              "type": "button",
              "text": "Login",
              "action": "navigate",
              "target": "login",
            },
          ],
        },
      ],
    };

    when(
      mockUIBloc.state,
    ).thenReturn(UIState(isLoading: false, uiConfig: uiConfig));
    when(mockUIBloc.stream).thenAnswer(
      (_) => Stream.value(UIState(isLoading: false, uiConfig: uiConfig)),
    );

    await tester.pumpWidget(createTestWidget("home"));

    await tester.tap(find.text("Login"));
    await tester.pumpAndSettle();

    verify(mockUIBloc.add(any)).called(1);
  });
}
