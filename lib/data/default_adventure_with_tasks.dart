import '../models/adventure.dart';
import '../models/challenge_task.dart';

Adventure createDefaultAdventureWithTasks() {
  return Adventure(
    id: 'adventure_with_tasks',
    title: 'Äventyr med utmaningar',
    nodes: {
      'start': AdventureNode(
        id: 'start',
        location: Location(
          name: 'Startplatsen',
          latitude: 57.689942,
          longitude: 11.990628,
        ),
        unlocked: true,
        tasks: [
          ChallengeTask(
            id: 'task1',
            title: 'Hälsa på någon!',
            description: 'Säg hej till någon du möter vid startplatsen.',
          ),
          ChallengeTask(
            id: 'task2',
            title: 'Kullebyttan',
            description: 'Gör 3 kullerbyttor på plats.',
            timeoutSeconds: 60,
          ),
          ChallengeTask(
            id: 'task3',
            title: 'Kullebyttan',
            description: 'Gör 3 kullerbyttor på plats.',
            question: "Hur många ben har en katt?",
            correctAnswers: ['4', 'fyra'],
            timeoutSeconds: 10,
          ),
        ],
        nextIds: ['park'],
      ),
      'park': AdventureNode(
        id: 'park',
        location: Location(
          name: 'Lilla Parken',
          latitude: 57.6905,
          longitude: 11.9912,
        ),
        tasks: [
          ChallengeTask(
            id: 'task3',
            title: 'Plocka upp skräp',
            description: 'Hitta och plocka upp minst 3 skräp i parken.',
          ),
          ChallengeTask(
            id: 'task4',
            title: 'Hoppa jämfota',
            description: 'Hoppa jämfota 10 gånger.',
            timeoutSeconds: 30,
          ),
        ],
        nextIds: ['brygga'],
      ),
      'brygga': AdventureNode(
        id: 'brygga',
        location: Location(
          name: 'Bryggan',
          latitude: 57.6901,
          longitude: 11.9885,
        ),
        tasks: [
          ChallengeTask(
            id: 'task5',
            title: 'Titta på vattnet',
            description: 'Stå tyst och titta på vattnet i 30 sekunder.',
            timeoutSeconds: 30,
          ),
          ChallengeTask(
            id: 'task6',
            title: 'Räkna båtar',
            description: 'Hur många båtar ser du? Skriv ner antalet.',
          ),
        ],
        nextIds: ['lekplats'],
      ),
      'lekplats': AdventureNode(
        id: 'lekplats',
        location: Location(
          name: 'Lekplatsen',
          latitude: 57.6893,
          longitude: 11.9920,
        ),
        tasks: [
          ChallengeTask(
            id: 'task7',
            title: 'Åk rutschkana',
            description: 'Åk ner för rutschkanan.',
          ),
          ChallengeTask(
            id: 'task8',
            title: 'Bygg ett sandslott',
            description: 'Bygg ett litet sandslott.',
          ),
        ],
        nextIds: ['skogsdunge'],
      ),
      'skogsdunge': AdventureNode(
        id: 'skogsdunge',
        location: Location(
          name: 'Skogsdungen',
          latitude: 57.6890,
          longitude: 11.9875,
        ),
        tasks: [
          ChallengeTask(
            id: 'task9',
            title: 'Hitta en kotte',
            description: 'Hitta och ta med dig en kotte.',
          ),
          ChallengeTask(
            id: 'task10',
            title: 'Lyssna på fåglar',
            description: 'Stå still och lyssna på fåglar i 1 minut.',
            timeoutSeconds: 60,
          ),
        ],
        nextIds: [],
      ),
    },
  );
}
