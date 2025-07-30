import 'package:flutter/material.dart';
import 'dart:async';
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
  @override
  void initState() {
    super.initState();
    if (widget.task.timeoutSeconds != null) {
      // Only start the countdown if the task has not been started yet
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
    final isTimed = widget.task.timeoutSeconds != null;
    final isCompleted = widget.task.completed;
    int remainingSeconds = 0;
    if (isTimed) {
      final adventureController = context.watch<AdventureController>();
      final key = '${widget.nodeId}|${widget.task.id}';
      remainingSeconds = adventureController.taskCountdowns[key] ?? 0;
    }
    return AlertDialog(
      backgroundColor: isTimed ? Colors.red[100] : null,
      title: Text(widget.task.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.task.description),
          if (isTimed)
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Text(
                remainingSeconds > 0
                    ? 'Tid kvar: $remainingSeconds s'
                    : 'Tiden är slut!',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
          if (!isTimed && !isCompleted)
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: ElevatedButton(
                onPressed: () {
                  widget.adventureController.completeTask(
                    widget.nodeId,
                    widget.task.id,
                  );
                  Navigator.pop(context);
                },
                child: const Text('Klar!'),
              ),
            ),
          if (isTimed && remainingSeconds <= 0 && !isCompleted)
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: ElevatedButton(
                onPressed: () {
                  widget.adventureController.completeTask(
                    widget.nodeId,
                    widget.task.id,
                  );
                  Navigator.pop(context);
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
  }
}
