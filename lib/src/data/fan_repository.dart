import 'package:hive/hive.dart';

import '../domain/models/fan_model.dart';

class FanRepository {
  final Box<FanModel> fanBox;

  FanRepository(this.fanBox);

  Future<List<FanModel>> getAllFans() async {
    return fanBox.values.toList();
  }

  Future<void> addFan(FanModel fan) async {
    await fanBox.put(fan.id, fan);
  }

  Future<void> deleteFan(String fanId) async {
    await fanBox.delete(fanId);
  }
}