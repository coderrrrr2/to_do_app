import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/models/to_do.dart';
import 'package:to_do_app/providers/settings_provider.dart';
import 'package:to_do_app/providers/to_do_provider.dart';
import 'package:to_do_app/screens/set_repeat_task_screen.dart';

final formatter = DateFormat.yMd();

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
 
  final formKey = GlobalKey<FormState>();
  final taskController = TextEditingController();
  DateTime? enteredDate;
  bool textformKeyIsEmpty = true;
  bool isDateSelected = false;
  TimeOfDay? selectedTime;
  String repeatDays = "No";
  Color darkHeaderColour = const Color.fromARGB(255, 156, 81, 231);

  void showDatePickerDialog() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year, now.month, now.day);
    final lastDate = DateTime(now.year + 18, now.month, now.day);

    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: lastDate);
    setState(() {
      enteredDate = pickedDate;
    });
  }

  void showTimePickerDialog() async {
    final pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );
    setState(() {
      selectedTime = pickedTime;
    });
  }

  void submitformKey(ToDo todo) {
    ref.read(toDoProvider.notifier).add(todo);
    Navigator.of(context).pop();
  }

  void updateEmpty() {
    setState(() {
      textformKeyIsEmpty = taskController.text.isEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    taskController.addListener(updateEmpty);
  }

  String formatTime(TimeOfDay timeOfDay) {
    final hour = timeOfDay.hourOfPeriod;
    final minute = timeOfDay.minute.toString().padLeft(2, '0');
    final period = timeOfDay.period == DayPeriod.am ? 'AM' : 'PM';

    return '$hour:$minute $period';
  }

  @override
  void dispose() {
    taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(settingsProvider);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text('New Task'),
          ),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 15, top: 30),
                          child: Text(
                            "What is to be done",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: theme.isLightMode
                                    ? Theme.of(context).colorScheme.primary
                                    : darkHeaderColour),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 30,
                      margin: const EdgeInsets.all(15),
                      child: TextFormField(
                        style: TextStyle(
                          color:
                              theme.isLightMode ? Colors.black : Colors.white,
                        ),
                        controller: taskController,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                            color:
                                theme.isLightMode ? Colors.black : Colors.white,
                          ),
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 15),
                          child: Text(
                            "Due Date",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: theme.isLightMode
                                    ? Theme.of(context).colorScheme.primary
                                    : darkHeaderColour),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 322,
                          margin: const EdgeInsets.all(15),
                          child: Text(
                            enteredDate == null
                                ? "Date Not Set"
                                : formatter.format(enteredDate!),
                            style: TextStyle(
                              color: theme.isLightMode
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: showDatePickerDialog,
                          icon: const Icon(Icons.calendar_month),
                          color:
                              theme.isLightMode ? Colors.black : Colors.white,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 15),
                          child: Text(
                            "Due Time",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: theme.isLightMode
                                    ? Theme.of(context).colorScheme.primary
                                    : darkHeaderColour),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(15),
                          width: 300,
                          child: Text(
                            selectedTime == null
                                ? "Time not set"
                                : formatTime(selectedTime!),
                            style: TextStyle(
                              color: theme.isLightMode
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: showTimePickerDialog,
                          icon: const Icon(Icons.timelapse),
                          color:
                              theme.isLightMode ? Colors.black : Colors.white,
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: Text(
                      "Repeat",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: theme.isLightMode
                              ? Theme.of(context).colorScheme.primary
                              : darkHeaderColour),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const RepeatTaskScreen(),
                    )),
                    child: Container(
                      width: 400,
                      margin: const EdgeInsets.all(15),
                      child: Row(
                        children: [
                          Text(
                            repeatDays,
                            style: TextStyle(
                              color: theme.isLightMode
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            (Icons.add_call),
                            color:
                                theme.isLightMode ? Colors.black : Colors.white,
                          )
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              )
            ],
          ),
          floatingActionButton: !textformKeyIsEmpty
              ? FloatingActionButton(
                  onPressed: () {
                    if (enteredDate != null &&
                        selectedTime != null &&
                        repeatDays != '') {
                      submitformKey(ToDo(
                          taskName: taskController.text,
                          date: enteredDate!,
                          time: selectedTime!,
                          repeatTaskDays: repeatDays));
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("You must select all options")));
                  },
                  child: const Icon(Icons.check),
                )
              : null),
    );
  }
}
