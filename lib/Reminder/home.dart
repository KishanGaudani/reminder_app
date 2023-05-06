import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/Constants/theme.dart';
import 'package:reminder_app/Reminder/details_screen.dart';
import 'package:reminder_app/Reminder/services.dart';
import 'widgets/action_buttons.dart';
import 'widgets/custom_day_picker.dart';
import 'widgets/date_field.dart';
import 'widgets/header.dart';
import 'widgets/time_field.dart';

class HomePage extends StatefulWidget {
  static const String pageRoute = "/HomePage";

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  NotificationService notificationService = NotificationService();

  final int maxTitleLength = 50;
  TextEditingController _textEditingController = TextEditingController();

  int segmentedControlGroupValue = 0;

  DateTime currentDate = DateTime.now();
  DateTime? eventDate;
  TimeOfDay currentTime = TimeOfDay.now();
  TimeOfDay? eventTime;

  Future<void> onCreate() async {
    await notificationService.showNotification(
      0,
      _textEditingController.text,
      'A new event has been created.',
      jsonEncode({
        'title': _textEditingController.text,
        'eventDate': DateFormat('EEEE, d MMM y').format(eventDate!),
        'eventTime': eventTime!.format(context),
      }),
    );

    await notificationService.scheduleNotification(
      1,
      _textEditingController.text,
      'Reminder for your scheduled event at ${eventTime!.format(context)}',
      eventDate!,
      eventTime!,
      jsonEncode({
        'title': _textEditingController.text,
        'eventDate': DateFormat('EEEE, d MMM y').format(eventDate!),
        'eventTime': eventTime!.format(context),
      }),
      getDateTimeComponents(),
    );
    resetForm();
  }

  Future<void> cancelAllNotifications() async {
    await notificationService.cancelAllNotifications();
  }

  void resetForm() {
    segmentedControlGroupValue = 0;
    eventDate = null;
    eventTime = null;
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  Widget _buildCancelAllButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.indigo[200],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Cancel all the reminders',
            style: GoogleFonts.pacifico(textStyle: const TextStyle(color: Colors.black,fontSize: 20,),),
          ),
          Icon(Icons.clear,color: Colors.black,),
        ],
      ),
    );
  }

  DateTimeComponents? getDateTimeComponents() {
    if (segmentedControlGroupValue == 1) {
      return DateTimeComponents.time;
    } else if (segmentedControlGroupValue == 2) {
      return DateTimeComponents.dayOfWeekAndTime;
    }
  }

  void selectEventDate() async {
    final today =
        DateTime(currentDate.year, currentDate.month, currentDate.day);
    if (segmentedControlGroupValue == 0) {
      eventDate = await showDatePicker(
        context: context,
        initialDate: today,
        firstDate: today,
        lastDate: DateTime(currentDate.year + 10),
      );
      setState(() {});
    } else if (segmentedControlGroupValue == 1) {
      eventDate = today;
    } else if (segmentedControlGroupValue == 2) {
      CustomDayPicker(
        onDaySelect: (val) {
          debugPrint('$val: ${CustomDayPicker.weekdays[val]}');
          eventDate = today.add(
              Duration(days: (val - today.weekday + 1) % DateTime.daysPerWeek));
        },
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ModelTheme themeNotifier, child){
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Reminder app",style: GoogleFonts.greatVibes(textStyle: const TextStyle(fontSize: 40,)),),
          elevation: 0.0,
          iconTheme: const IconThemeData(color: Colors.black),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const DetailsScreen(payload: null)),
                );
              },
              icon: const Icon(
                Icons.library_books_rounded,
                color: Colors.black,
              ),
            ),
          ],
          leading: IconButton(
            icon: Icon(
                themeNotifier.isDark ? Icons.nightlight_round : Icons.wb_sunny),
            onPressed: () {
              themeNotifier.isDark
                  ? themeNotifier.isDark = false
                  : themeNotifier.isDark = true;
            },
          ),
        ),
        body: Center(
          child: Container(
            height: double.infinity,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  spreadRadius: 5,
                  blurRadius: 5,
                  color: Colors.grey.withOpacity(0.4),
                  offset: Offset(0, 0),
                )
              ],
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 20,),
                    const Header(),
                    SizedBox(height: 20,),
                    TextFormField(
                      controller: _textEditingController,
                      maxLength: maxTitleLength,
                      decoration: InputDecoration(
                        hintText: "Add event",
                        hintStyle: GoogleFonts.lobster(textStyle: const TextStyle(fontSize: 20,),),
                      ),
                    ),
                    const SizedBox(height: 20),
                    CupertinoSlidingSegmentedControl<int>(
                      onValueChanged: (value) {
                        if (value == 1) eventDate = null;
                        setState(() => segmentedControlGroupValue = value!);
                      },
                      groupValue: segmentedControlGroupValue,
                      padding: const EdgeInsets.all(5),
                      children: <int, Widget>{
                        0: Text('One time',style: GoogleFonts.pacifico(textStyle: const TextStyle(fontSize: 20,),),),
                        1: Text('Daily',style: GoogleFonts.pacifico(textStyle: const TextStyle(fontSize: 20,),),),
                        2: Text('Weekly',style: GoogleFonts.pacifico(textStyle: const TextStyle(fontSize: 20,),),)
                      },
                    ),
                    SizedBox(height: 25,),
                    Text('Date & Time',style: GoogleFonts.pacifico(textStyle: const TextStyle(fontSize: 20,),),),
                    const SizedBox(height: 12.0),
                    GestureDetector(
                      onTap: selectEventDate,
                      child: DateField(eventDate: eventDate),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () async {
                        eventTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay(
                            hour: currentTime.hour,
                            minute: currentTime.minute + 1,
                          ),
                        );
                        setState(() {});
                      },
                      child: TimeField(eventTime: eventTime),
                    ),
                    const SizedBox(height: 20),
                    ActionButtons(
                      onCreate: onCreate,
                      onCancel: resetForm,
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () async {
                        await cancelAllNotifications();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('All notfications cancelled'),
                          ),
                        );
                      },
                      child: _buildCancelAllButton(),
                    ),
                    SizedBox(height: 20,),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
