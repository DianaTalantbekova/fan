import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../../data/fan_repository.dart';
import '../../../../domain/models/fan_model.dart';

part 'fan_event.dart';
part 'fan_state.dart';

class FanBloc extends Bloc<FanEvent, FanState> {
  final FanRepository fanRepository;

  FanBloc(this.fanRepository) : super(FanInitial()) {
    on<LoadFans>((event, emit) async {
      emit(FanLoading());
      try {
        final fans = await fanRepository.getAllFans();
        emit(FanLoaded(fans));
      } catch (e) {
        emit(FanError(e.toString()));
      }
    });

    on<AddFan>((event, emit) async {
      try {
        await fanRepository.addFan(event.fan);
        emit(FanLoaded(await fanRepository.getAllFans()));

      } catch (e) {
        emit(FanError(e.toString()));
      }
    });

    on<DeleteFan>((event, emit) async {
      try {
        await fanRepository.deleteFan(event.fanId);
        emit(FanLoaded(await fanRepository.getAllFans()));
      } catch (e) {
        emit(FanError(e.toString()));
      }
    });
  }
}