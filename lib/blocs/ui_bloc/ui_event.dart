part of 'ui_bloc.dart';

@immutable
abstract class UiEvent extends  Equatable{
  @override
  List<Object?> get props => [];
}


class LoadUiEvent extends UiEvent{
}

class ToggleThemeEvent extends UiEvent {}