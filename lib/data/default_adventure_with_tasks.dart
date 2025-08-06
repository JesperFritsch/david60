import '../models/adventure.dart';
import '../models/challenge_task.dart';

/*

Hotell flora:

paddan bryggan:
Ta dig på livflotten och förklara för dina följare varför det är viktigt att behålla lugnet och undvika panik under kris

kopparmärra:
Riktmärken är viktigt för att kunna navigera runt om i vildmarken, du har precis kommit till ett viktigt riktmärke i staden. Förklara för dina följare vad som är viktigt att tänka på för att kunna navigera i det vilda. (Siri: Kompass + karta)

domkyrkan:
Förklara för alla dina följare vad som är bra med jordförbindelse och demonstrera med inlevelse.

naturkompaniet stora nygatan:
gå in på naturkompaniet och säg “Hej jag heter David, jag fyller 60 år idag” till personalen

trädgårdsföreningen:
Gör en unboxing och reviewa paketet för dina följare
du har 60 sekunder på dig att göra 6 kullerbyttor

brygghuset:
Hitta en plats för vätskepaus 
Förklara för dina följare varför det är viktigt med vätskepauser

götaplatsen:
Vackra vyer är en anledning att ta sig ut i naturen, förklara varför det är viktigt för människan att ha fina vyer

Jesper:


*/

Adventure createDefaultAdventureWithTasks() {
  return Adventure(
    id: 'david60',
    title: '60 års äventyr',
    nodes: {
      'start': AdventureNode(
        id: 'start',
        unlocked: true,
        location: Location(
          name: "Startplatsen",
          latitude: 57.77940631797856,
          longitude: 12.23518199463353,
        ),
        tasks: [
          ChallengeTask(
            id: 'task1_1',
            title: 'Första uppgiften',
            description: 'Beskrivning av första uppgiften',
          ),
        ],
        nextIds: ["node1"],
      ),
      'node1': AdventureNode(
        id: 'node1',
        location: Location(
          name: "åkareplatsen",
          latitude: 57.707854,
          longitude: 11.976026,
        ),
        tasks: [
          ChallengeTask(
            id: 'task2_1',
            title: 'Andra uppgiften',
            description: 'Beskrivning av andra uppgiften',
          ),
        ],
        nextIds: ["node2"],
      ),
      'node2': AdventureNode(
        id: 'node2',
        location: Location(
          name: "Hotell flora",
          latitude: 57.702796009553666,
          longitude: 11.965639315381878,
        ),
        tasks: [],
        nextIds: ["node3"],
      ),
      'node3': AdventureNode(
        id: 'node3',
        location: Location(
          name: "paddan bryggan",
          latitude: 57.703268,
          longitude: 11.969409,
        ),
        tasks: [
          ChallengeTask(
            id: 'task4_1',
            title: 'Livflotten',
            description: 'Ta dig på livflotten.',
          ),
          ChallengeTask(
            id: 'task4_2',
            title: 'Kris och lugn',
            description:
                'Förklara för dina följare varför det är viktigt att behålla lugnet och undvika panik under kris.',
          ),
        ],
        nextIds: ["node4"],
      ),
      'node4': AdventureNode(
        id: 'node4',
        location: Location(
          name: "Kopparmärra",
          latitude: 57.704520,
          longitude: 11.969618,
        ),
        tasks: [
          ChallengeTask(
            id: 'task5_1',
            title: 'Hitta riktmärke',
            description: 'Hitta ett viktigt riktmärke i staden.',
          ),
          ChallengeTask(
            id: 'task5_2',
            title: 'Navigera',
            description:
                'Visa hur du använder kompass och karta för att navigera i det vilda.',
          ),
        ],
        nextIds: ["node5"],
      ),
      'node5': AdventureNode(
        id: 'node5',
        location: Location(
          name: "Domkyrkan",
          latitude: 57.704508,
          longitude: 11.964536,
        ),
        tasks: [
          ChallengeTask(
            id: 'task6_1',
            title: 'Berätta om jordförbindelse',
            description:
                'Berätta för dina följare vad som är bra med jordförbindelse.',
          ),
          ChallengeTask(
            id: 'task6_2',
            title: 'Demonstrera jordförbindelse',
            description: 'Visa och demonstrera jordförbindelse med inlevelse.',
          ),
        ],
        nextIds: ["node6"],
      ),
      'node6': AdventureNode(
        id: 'node6',
        location: Location(
          name: "Naturkompaniet Stora Nygatan",
          latitude: 57.704092,
          longitude: 11.970884,
        ),
        tasks: [
          ChallengeTask(
            id: 'task7_1',
            title: 'Social utmaning',
            description:
                'Gå in på Naturkompaniet och säg “Hej jag heter David, jag fyller 60 år idag” till personalen.',
          ),
        ],
        nextIds: ["node7"],
      ),
      'node7': AdventureNode(
        id: 'node7',
        location: Location(
          name: "Trädgårdsföreningen",
          latitude: 57.705671,
          longitude: 11.974643,
        ),
        tasks: [
          ChallengeTask(
            id: 'task8_1',
            title: 'Unboxing',
            description:
                'Gör en unboxing och reviewa paketet för dina följare.',
          ),
          ChallengeTask(
            id: 'task8_2',
            title: 'Kullerbyttor',
            description: 'Du har 60 sekunder på dig att göra 6 kullerbyttor.',
            timeoutSeconds: 60,
          ),
        ],
        nextIds: ["node8"],
      ),
      'node8': AdventureNode(
        id: 'node8',
        location: Location(
          name: "Brygghuset",
          latitude: 57.703935,
          longitude: 11.968880,
        ),
        tasks: [
          ChallengeTask(
            id: 'task9_1',
            title: 'Vätskepaus',
            description: 'Hitta en plats för vätskepaus.',
          ),
          ChallengeTask(
            id: 'task9_2',
            title: 'Vätskepauser',
            description:
                'Förklara för dina följare varför det är viktigt med vätskepauser.',
          ),
        ],
        nextIds: ["node9"],
      ),
      'node9': AdventureNode(
        id: 'node9',
        location: Location(
          name: "Götaplatsen",
          latitude: 57.69721080004185,
          longitude: 11.979585057910219,
        ),
        tasks: [
          ChallengeTask(
            id: 'task10_2',
            title: 'Varför vyer är viktiga',
            description:
                'Förklara varför det är viktigt för människan att ha fina vyer.',
          ),
        ],
        nextIds: ["node10"],
      ),
      // 57.689989, 11.990457
      'node10': AdventureNode(
        id: 'node10',
        location: Location(
          name: "Jespers",
          latitude: 57.689989,
          longitude: 11.990457,
        ),
        tasks: [
          ChallengeTask(
            id: 'task11_1',
            title: 'Elfte uppgiften',
            description: 'Beskrivning av elfte uppgiften',
          ),
        ],
      ),
      // Add more nodes and tasks as needed
    },
  );
}
