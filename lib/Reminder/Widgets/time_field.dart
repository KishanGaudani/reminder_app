import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TimeField extends StatelessWidget {
  const TimeField({Key? key, required this.eventTime}) : super(key: key);
  final TimeOfDay? eventTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
      ),
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              eventTime == null
                  ? "Select the event time"
                  : eventTime!.format(context),
              style: GoogleFonts.pacifico(
                textStyle: TextStyle(fontSize: 18,),
              ),
            ),
          ),
          Icon(
            Icons.timer_rounded,
            size: 18.0,
          ),
        ],
      ),
    );
  }
}
