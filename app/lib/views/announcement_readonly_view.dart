import 'package:app/components/typography.dart';
import 'package:app/models/announcement.dart';
import 'package:app/utils/colors.dart';
import 'package:app/utils/sizes.dart';
import 'package:flutter/material.dart';

class AnnouncementReadonlyView extends StatelessWidget {
  final Announcement ann;

  const AnnouncementReadonlyView(this.ann, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.chevron_left_rounded, size: 32, color: Palette.gray500,), 
            onPressed: () {},
          ),
        ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.lg, vertical: Spacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
           children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Heading(order: 1, text: ann.title, textAlign: TextAlign.start, style: const TextStyle(fontWeight: FontWeight.bold, color: Palette.gray800)),
                const Text("Thursday, 3rd July 2024", style: TextStyle(
                  color: Palette.gray600,
                  fontWeight: FontWeight.bold,
                  fontSize: FontSize.sm
                ))
              ],
            ),
            const SizedBox(height: Spacing.lg),
            Text(ann.body, style: const TextStyle(
              color: Palette.gray600,
              fontSize: FontSize.base
            ))
          
           ],
          ),
        ),
      )
    );
  } 
}
