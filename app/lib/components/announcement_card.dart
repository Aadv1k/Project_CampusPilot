import 'package:app/models/announcement.dart';
import 'package:app/utils/colors.dart';
import 'package:app/utils/sizes.dart';
import 'package:app/views/announcement_readonly_view.dart';
import 'package:flutter/material.dart';

String extractHourAndMinute(String isoString) {
  DateTime dateTime = DateTime.parse(isoString);
  String formattedTime = '${dateTime.hour.toString().padLeft(2, '0')}:'
      '${dateTime.minute.toString().padLeft(2, '0')}';
  return formattedTime;
}

class AnnouncementCard extends StatelessWidget {
  final String id;
  final String title;
  final String body;
  final String authorName;
  final String postedAt;
  late String sanitizedBody;

  final int maxSummaryWords = 16;

  AnnouncementCard(
      this.id, this.title, this.body, this.authorName, this.postedAt,
      {super.key}) {
    sanitizedBody = sanitizeText(body);
  }

  String sanitizeText(String body) {
    return body.replaceAll(RegExp(r'[\n\r]'), ' ');
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        splashColor: Palette.slate200,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AnnouncementReadonlyView(
                    Announcement(id, title, body, authorName, postedAt))),
          );
        },
        child: Container(
          decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Palette.slate100, width: 2.0))),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: Spacing.lg, horizontal: Spacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(authorName,
                        style: const TextStyle(
                            fontSize: FontSize.sm, color: Palette.slate500)),
                    Text(extractHourAndMinute(postedAt),
                        style: const TextStyle(
                            fontSize: FontSize.sm,
                            color: Palette.slate500,
                            fontWeight: FontWeight.bold)),
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
                          color: Palette.slate900,
                          fontWeight: FontWeight.bold,
                          fontSize: FontSize.md),
                    ),
                    const SizedBox(height: Spacing.xs),
                    Text(sanitizedBody,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Palette.slate700, fontSize: FontSize.base))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
