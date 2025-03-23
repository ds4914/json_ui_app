part of 'ui_bloc.dart';

@immutable
class UIState extends Equatable {
  final Map<String, dynamic>? uiConfig;
  bool? isLoading;
  final bool isDarkMode;
  UIState({this.isLoading = false, this.uiConfig, this.isDarkMode = false});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is UIState &&
          runtimeType == other.runtimeType &&
          uiConfig == other.uiConfig &&
          isLoading == other.isLoading;

  UIState copyWith({Map<String, dynamic>? uiConfig, bool? isLoading,bool? isDarkMode}) {
    return UIState(
      uiConfig: uiConfig ?? this.uiConfig,
      isLoading: isLoading ?? this.isLoading,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }

  @override
  int get hashCode => super.hashCode ^ uiConfig.hashCode ^ isLoading.hashCode;

  @override
  List<Object?> get props => [uiConfig, isLoading,isDarkMode];
}
