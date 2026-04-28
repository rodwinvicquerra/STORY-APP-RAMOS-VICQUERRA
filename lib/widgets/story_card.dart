import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StoryCard extends StatelessWidget {
  final String text;

  const StoryCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        color: const Color(0xFF16213E),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SingleChildScrollView(
            child: Text(
              text,
              style: GoogleFonts.nunito(
                color: const Color(0xFFE0E0E0),
                fontSize: 15.5,
                height: 1.65,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
