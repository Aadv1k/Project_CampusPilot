import 'package:app/components/typography.dart';
import 'package:app/models/announcement.dart';
import 'package:app/utils/colors.dart';
import 'package:app/utils/sizes.dart';
import 'package:flutter/material.dart';

String parseDateTimeToString(String isoString) {
  DateTime dateTime = DateTime.parse(isoString);
  String formattedDate =
      '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  return formattedDate;
}

class AnnouncementReadonlyView extends StatelessWidget {
  final Announcement ann;

  const AnnouncementReadonlyView(this.ann, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.chevron_left_rounded,
              size: 32,
              color: Palette.slate500,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Spacing.lg, vertical: Spacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Heading(
                        order: 1,
                        text: ann.title,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Palette.slate950)),
                    const SizedBox(height: Spacing.sm),
                    Text(parseDateTimeToString(ann.postedAt),
                        style: const TextStyle(
                            color: Palette.slate600,
                            fontSize: FontSize.sm))
                  ],
                ),
                const SizedBox(height: Spacing.lg),
                Text(ann.body,
                    style: const TextStyle(
                        color: Palette.slate800, fontSize: FontSize.base))
              ],
            ),
          ),
        ));
  }
}
