// lib/data/default_adventure.dart
import '../models/adventure.dart';

Adventure createDefaultAdventure() {
  return Adventure(
    id: 'mamma_test',
    title: 'Morsans öland test',
    nodes: {
      'start': AdventureNode(
        id: 'start',
        location: Location(
          name: 'Startplatsen',
          latitude: 56.238008,
          longitude: 16.453580,
        ),
        quest: 'Tjena morsan - här börjar äventyret!',
        unlocked: true,
        nextIds: ['church', 'masten'],
      ),
      'church': AdventureNode(
        id: 'church',
        location: Location(
          name: 'Ås kyrka',
          latitude: 56.238225,
          longitude: 16.448830,
        ),
        quest: 'räkna hur många fönster det finns i kyrkan.',
        nextIds: ['dungen'],
      ),
      'masten': AdventureNode(
        id: 'masten',
        location: Location(
          name: 'Höga masten',
          latitude: 56.233740,
          longitude: 16.454664,
        ),
        quest: 'Gissa hug hög masten är',
      ),
      'dungen': AdventureNode(
        id: 'dungen',
        location: Location(
          name: 'Några träd',
          latitude: 56.239943,
          longitude: 16.449638,
        ),
        quest: 'Hitta en kotte eller en fin sten',
        nextIds: ['stugan'],
      ),
      'stugan': AdventureNode(
        id: 'stugan',
        location: Location(
          name: 'Stugan vid vägen',
          latitude: 56.238097,
          longitude: 16.446755,
        ),
        quest: 'kolla ifall det finns en nyckel under mattan',
      ),
    },
  );
}
