import 'package:app/components/button.dart';
import 'package:app/components/scope_selector.dart';
import 'package:app/utils/colors.dart';
import 'package:app/utils/sizes.dart';
import 'package:flutter/material.dart';

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

  void _showScopeSelectionSheet(BuildContext context) {

    showModalBottomSheet(
      context: context, 
      isScrollControlled: true,
      enableDrag: false,
      isDismissible: false,
      builder: (BuildContext childContext) {
        return Container(
          height: MediaQuery.sizeOf(context).height * 0.75,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: Spacing.lg),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(Radii.lg), topRight: Radius.circular(Radii.lg))
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Padding(
                padding: EdgeInsets.symmetric(horizontal: Spacing.lg),
                child: Text("Select an Audience", style: TextStyle(fontWeight: FontWeight.bold, fontSize: FontSize.lg)),
              ),
              SizedBox(height: Spacing.md),
              ScopeSelectorMenu() 
            ],
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          backgroundColor: Palette.offWhite100,
          leading: IconButton(
            icon: const Icon(
              Icons.chevron_left_rounded,
              size: 32,
              color: Palette.slate600,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: Spacing.md, horizontal: Spacing.lg),
              decoration: const BoxDecoration(
                color: Palette.offWhite100,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35), bottomRight: Radius.circular(35)),
              ),
              child: Column(
                children: [
                  TextField(
                    maxLines: null,
                    controller: _titleController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(fontSize: FontSize.lg, color: Palette.slate600),
                      hintText: "Announcement Title..."
                    ),
                    style: const TextStyle(fontSize: FontSize.lg, color: Palette.slate800, fontWeight: FontWeight.bold)
                  ),
                  const SizedBox(height: Spacing.sm),
                  CustomOutlinedButton(onPressed: () => _showScopeSelectionSheet(context), text: "No Scopes Selected", icon: Icons.arrow_drop_down_sharp, width: double.infinity)

                ],
              ),
            )
          ],
        ));
  }
}
