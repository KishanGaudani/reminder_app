import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DateField extends StatelessWidget {
  const DateField({Key? key, required this.eventDate}) : super(key: key);
  final DateTime? eventDate;

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
              eventDate == null
                  ? "Select the event day"
                  : DateFormat("EEEE, d MMM y").format(eventDate!),
              style: GoogleFonts.pacifico(
                textStyle: TextStyle(fontSize: 18,),
              ),
            ),
          ),
          Icon(
            Icons.calendar_today_outlined,
            size: 18.0,
          ),
        ],
      ),
    );
  }
}
