import 'package:hive/hive.dart';
import '../models/adventure.dart';
import 'interface/adventure_interface.dart';

class HiveAdventureRepository implements IAdventureRepository {
  final String boxName;

  HiveAdventureRepository({this.boxName = 'adventures'});

  Future<Box<Adventure>> _openBox() async {
    return await Hive.openBox<Adventure>(boxName);
  }

  @override
  Future<void> saveAdventure(Adventure adventure) async {
    final box = await _openBox();
    await box.put(adventure.id, adventure);
  }

  @override
  Future<Adventure?> loadAdventure(String id) async {
    final box = await _openBox();
    return box.get(id);
  }

  @override
  Future<List<Adventure>> loadAllAdventures() async {
    final box = await _openBox();
    return box.values.toList();
  }

  @override
  Future<void> deleteAdventure(String id) async {
    final box = await _openBox();
    await box.delete(id);
  }
}
