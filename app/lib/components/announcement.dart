import 'package:app/components/typography.dart';
import 'package:app/utils/colors.dart';
import 'package:app/utils/sizes.dart';
import 'package:flutter/material.dart';

class AnnouncementCard extends StatelessWidget{
  final String id;
  final String title;
  final String body;
  final String authorName;
  final bool highPriority;
  late String textSummary;

  final int maxSummaryWords = 24; 

  AnnouncementCard(this.id, this.title, this.body, this.authorName, this.highPriority, {super.key}) {
    textSummary = generateTextSummary(body);
  }

String generateTextSummary(String body) {
  List<String> words = body.replaceAll(RegExp(r'[\n\r]'), ' ').split(' ');

  if (words.length <= maxSummaryWords) {
    return words.join(' ');
  } else {
    return "${words.sublist(0, maxSummaryWords).join(' ')}...";
  }
}


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.lg, horizontal: Spacing.md),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(authorName, style: const TextStyle( fontSize: FontSize.md, color: Palette.gray400)),
              const Text("3:30 pm", style: TextStyle( fontSize: FontSize.md, color: Palette.gray600)),
            ],
          ),
          const SizedBox(height: Spacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Heading(
                order: 4,
                text: title,
                style: const TextStyle(
                    color: Palette.gray900, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: Spacing.sm),
              Text(
                textSummary,
                style: const TextStyle(
                  color: Palette.gray600,
                  fontSize: FontSize.md
                )
              )
            ],
          )
        ],
      ),
    );
  }
}