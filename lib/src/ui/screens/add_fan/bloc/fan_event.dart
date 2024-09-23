part of 'fan_bloc.dart';

@immutable
abstract class FanEvent {}

class LoadFans extends FanEvent {}

class AddFan extends FanEvent {
  final FanModel fan;

  AddFan(this.fan);
}

class DeleteFan extends FanEvent {
  final String fanId;

  DeleteFan(this.fanId);
}