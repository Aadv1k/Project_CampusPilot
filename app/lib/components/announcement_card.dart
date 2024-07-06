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
  late String sanitizedBody;

  final int maxSummaryWords = 16; 

  AnnouncementCard(this.id, this.title, this.body, this.authorName, this.highPriority, {super.key}) {
    sanitizedBody = sanitizeText(body);
  }

  String sanitizeText(String body) {
    return body.replaceAll(RegExp(r'[\n\r]'), ' ');
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () => print("tapped bro"),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Spacing.lg, horizontal: Spacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(authorName, style: const TextStyle( fontSize: FontSize.sm, color: Palette.gray400)),
                  const Text("3:30 pm", style: TextStyle( fontSize: FontSize.sm, color: Palette.gray500, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: Spacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        color: Palette.gray900, fontWeight: FontWeight.bold, fontSize: FontSize.md
                        ),
                  ),
                  const SizedBox(height: Spacing.xs),
                  Text(
                    sanitizedBody,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Palette.gray600,
                      fontSize: FontSize.base
                    )
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}