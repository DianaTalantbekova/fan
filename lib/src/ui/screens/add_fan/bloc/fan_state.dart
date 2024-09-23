part of 'fan_bloc.dart';

@immutable
abstract class FanState {}

class FanInitial extends FanState {}

class FanLoading extends FanState {}

class FanLoaded extends FanState {
  final List<FanModel> fans;

  FanLoaded(this.fans);
}

class FanError extends FanState {
  final String message;

  FanError(this.message);
}