import 'package:app/components/scope_selector.dart';
import 'package:app/models/announcement.dart';
import 'package:app/utils/colors.dart';
import 'package:app/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnnouncementCreateView extends StatefulWidget {
  const AnnouncementCreateView({super.key});

  @override
  State<AnnouncementCreateView> createState() => _AnnouncementCreateViewState();
}

class _AnnouncementCreateViewState extends State<AnnouncementCreateView> {
  final TextEditingController _titleController = TextEditingController();
  String? announcementTitle;

  @override
  void initState() {
    _titleController.addListener(() {
      setState(() {
        announcementTitle = _titleController.value.text;
      });
    });
    super.initState();
  } 

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          backgroundColor: Palette.white,
          leading: IconButton(
            icon: const Icon(
              Icons.chevron_left_rounded,
              size: 32,
              color: Palette.gray500,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Spacing.lg, vertical: Spacing.md),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                maxLines: null,
                controller: _titleController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintStyle: TextStyle(fontSize: FontSize.lg, color: Palette.slate400),
                  hintText: "Announcement Title..."
                ),
                style: TextStyle(fontSize: FontSize.lg, color: Palette.slate800)
              ),

              const SizedBox(height: Spacing.md),

              const ScopeSelector()
            ],
          ),
        ));
  }
}
