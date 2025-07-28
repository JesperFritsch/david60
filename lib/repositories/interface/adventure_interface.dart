import 'package:waypoints/models/adventure.dart';

abstract class IAdventureRepository {
  Future<void> saveAdventure(Adventure adventure);
  Future<Adventure?> loadAdventure(String id);
  Future<List<Adventure>> loadAllAdventures();
  Future<void> deleteAdventure(String id);
}
