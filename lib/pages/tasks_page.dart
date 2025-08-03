import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/adventure_controller.dart';
import '../models/challenge_task.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final adventureController = context.watch<AdventureController>();
    final adventure = adventureController.adventure;
    if (adventure == null) {
      return const Center(child: CircularProgressIndicator());
    }
    // Group unlocked tasks by node
    final nodesWithUnlockedTasks =
        adventure.nodes.values
            .where((node) => node.tasks.any((t) => t.unlocked))
            .toList();
    if (nodesWithUnlockedTasks.isEmpty) {
      return const Center(child: Text('Inga upplåsta uppgifter ännu.'));
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final node in nodesWithUnlockedTasks) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              node.location.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          ...node.tasks
              .where((task) => task.unlocked)
              .map(
                (task) => ListTile(
                  title: Text(task.startedAt != null ? task.title : "Utmaning"),
                  subtitle: Text(
                    task.startedAt != null
                        ? task.description
                        : 'Klicka för att öppna',
                  ),
                  trailing:
                      task.completed
                          ? const Text(
                            'Klar',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                          : (task.timeoutSeconds != null &&
                                  task.startedAt != null
                              ? Builder(
                                builder: (context) {
                                  final adventureController =
                                      context.watch<AdventureController>();
                                  final key = '${node.id}|${task.id}';
                                  final remainingSeconds =
                                      adventureController.taskCountdowns[key] ??
                                      0;
                                  return Text('Tid kvar: $remainingSeconds s');
                                },
                              )
                              : const Text(
                                'Ej klar',
                                style: TextStyle(color: Colors.red),
                              )),
                  onTap: () async {
                    adventureController.startTask(node.id, task.id);
                    await showDialog(
                      context: context,
                      builder:
                          (context) => _TaskInfoDialog(
                            task: task,
                            nodeId: node.id,
                            adventureController: adventureController,
                          ),
                    );
                  },
                ),
              ),
          const Divider(),
        ],
      ],
    );
  }
}

class _TaskInfoDialog extends StatefulWidget {
  final ChallengeTask task;
  final String nodeId;
  final AdventureController adventureController;
  const _TaskInfoDialog({
    required this.task,
    required this.nodeId,
    required this.adventureController,
  });

  @override
  State<_TaskInfoDialog> createState() => _TaskInfoDialogState();
}

class _TaskInfoDialogState extends State<_TaskInfoDialog> {
  String _userAnswer = '';
  @override
  void initState() {
    super.initState();
    if (widget.adventureController.isTaskTimed(widget.task)) {
      widget.adventureController.startTaskCountdown(
        widget.nodeId,
        widget.task.id,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdventureController>(
      builder: (context, adventureController, _) {
        // Always get the latest task from the controller
        final node = adventureController.adventure?.nodes[widget.nodeId];
        final task = node?.tasks.firstWhere(
          (t) => t.id == widget.task.id,
          orElse: () => widget.task,
        );
        if (task == null) {
          return const AlertDialog(
            content: Text('Kunde inte hitta uppgiften.'),
          );
        }
        final isTimed = adventureController.isTaskTimed(task);
        final isCompleted = adventureController.isTaskCompleted(task);
        final hasQuestion = adventureController.hasTaskQuestion(task);
        final completeWithinTime = adventureController
            .isTaskCompletedWithinTime(task);
        Color? bgColor;
        if (isTimed && isCompleted) {
          bgColor = completeWithinTime ? Colors.green[100] : Colors.red[100];
        } else if (isTimed) {
          bgColor = Colors.red[100];
        }
        return AlertDialog(
          backgroundColor: bgColor,
          title: Text(task.title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(task.description),
              if (isTimed)
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Builder(
                    builder: (context) {
                      final key = '${widget.nodeId}|${task.id}';
                      final remainingSeconds =
                          adventureController.taskCountdowns[key] ?? 0;
                      String countdownText;
                      if (isCompleted) {
                        countdownText =
                            completeWithinTime
                                ? 'Rätt svar!'
                                : 'Tiden gick ut!';
                      } else {
                        countdownText =
                            remainingSeconds > 0
                                ? 'Tid kvar: $remainingSeconds s'
                                : 'Tiden är ute!';
                      }
                      return Text(
                        countdownText,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      );
                    },
                  ),
                ),
              if (!isCompleted && hasQuestion)
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: TextField(
                    onChanged: (value) {
                      setState(() => _userAnswer = value);
                      if (_userAnswer.isNotEmpty &&
                          (task.correctAnswers?.any(
                                (ans) =>
                                    ans.toLowerCase().trim() ==
                                    _userAnswer.toLowerCase().trim(),
                              ) ??
                              false)) {
                        adventureController.completeTask(
                          widget.nodeId,
                          task.id,
                        );
                        setState(() {});
                      }
                    },
                    decoration: const InputDecoration(labelText: 'Ditt svar'),
                  ),
                ),
              if (!isCompleted && !hasQuestion)
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: ElevatedButton(
                    onPressed: () {
                      adventureController.completeTask(widget.nodeId, task.id);
                      setState(() {});
                    },
                    child: const Text('Klar!'),
                  ),
                ),
              if (isCompleted)
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Text(
                    'Uppgiften är klar!',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Stäng'),
            ),
          ],
        );
      },
    );
  }
}
