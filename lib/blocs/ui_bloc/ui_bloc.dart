import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:jsonuiapp/services/ui_service.dart';
import 'package:meta/meta.dart';

part 'ui_event.dart';
part 'ui_state.dart';

class UIBloc extends Bloc<UiEvent, UIState> {
  final UIService uiService;
  UIBloc(this.uiService) : super(UIState()) {
    on<LoadUiEvent>(_loadUiEvent);
    on<ToggleThemeEvent>(_toggleThemeEvent);
  }

  Future<void> _loadUiEvent(LoadUiEvent event, Emitter<UIState> emit) async {
    try {
      print("Loading UI JSON...");
      emit(state.copyWith(isLoading: true));

      final jsonConfig = await uiService.loadUIConfig();
      print("Loaded JSON: $jsonConfig");

      emit(state.copyWith(uiConfig: jsonConfig, isLoading: false));
    } catch (e) {
      print("Error loading JSON: $e");
      emit(state.copyWith(isLoading: false));
    }
  }

  void _toggleThemeEvent(ToggleThemeEvent event, Emitter<UIState> emit) {
    emit(state.copyWith(isDarkMode: !state.isDarkMode));
  }
}
