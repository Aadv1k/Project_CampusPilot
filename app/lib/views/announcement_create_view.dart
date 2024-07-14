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
                  hintStyle: TextStyle(fontSize: FontSize.xl, color: Palette.slate400),
                  hintText: "Announcement Title..."
                ),
                style: TextStyle(fontSize: FontSize.xl, fontWeight: FontWeight.bold)
              ),

              const SizedBox(height: Spacing.md),

              Container(
                height: MediaQuery.sizeOf(context).height / 3,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                decoration: BoxDecoration(
                  color: Palette.offWhite100,
                  border: Border.all(color: Palette.slate200, width: 1),
                  borderRadius: BorderRadius.circular(Radii.sm)
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(border: Border(right: BorderSide(color: Palette.slate300, width: 1))),
                        child: const Column(children: [
                          ScopeSelectorItem(text: "Students", ),
                          ScopeSelectorItem(text: "Teachers"),
                        ],)
                      ),
                    ),
                
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(decoration: const BoxDecoration(border: Border(right: BorderSide(color: Palette.slate300, width: 1))),
                          child: const Column(children: [
                            ScopeSelectorItem(text: "6th"),
                            ScopeSelectorItem(text: "7th"),
                            ScopeSelectorItem(text: "8th"),
                            ScopeSelectorItem(text: "9th"),
                            ScopeSelectorItem(text: "10th"),
                            ScopeSelectorItem(text: "11th"),
                            ScopeSelectorItem(text: "12th"),
                          ],)
                        ),
                      ),
                    ),


                    Expanded(child: Container())
                  ],
                )
              )
            ],
          ),
        ));
  }
}

class ScopeSelectorItem extends StatelessWidget {
  const ScopeSelectorItem({required this.text, super.key, this.active});

  final String text;
  final bool? active;

  final double _accentBorderSize = 5;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: active != null ? Palette.lightBlue.withOpacity(0.3) : null,
        border: Border(left: BorderSide(color: active == true ? Palette.lightBlue : Colors.transparent, width: _accentBorderSize)),
      ),

      padding: const EdgeInsets.only(left: Spacing.xs, right: Spacing.md, top: Spacing.lg, bottom: Spacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: FontSize.sm,
                  color: Palette.slate600,
                )),
          ),

          const Icon(Icons.chevron_right_rounded, color: Palette.slate400, size: Widths.xs)
        ],
      ),
    );
  }
}