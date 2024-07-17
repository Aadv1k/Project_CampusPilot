import 'package:app/components/button.dart';
import 'package:app/components/chips.dart';
import 'package:app/components/scope_selector.dart';
import 'package:app/models/announcement.dart';
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
  List<AnnouncementScope> _announcementScopes = [];

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
      isDismissible: true,
      builder: (BuildContext childContext) {
        return Container(
          height: MediaQuery.sizeOf(context).height * 0.75,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: Spacing.lg),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(Radii.lg), topRight: Radius.circular(Radii.lg))
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: Spacing.lg),
                child: Text("Select Audience", style: TextStyle(fontWeight: FontWeight.bold, fontSize: FontSize.lg)),
              ),
              const SizedBox(height: Spacing.lg),
              Expanded(
                child: ScopeSelectorMenu(
                  onChange: (data) {
                    setState(() {
                      _announcementScopes = data;
                    });
                  },
                ),
              ),
              const SizedBox(height: Spacing.lg),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [ 
                    CustomTextButton(
                      onPressed: () { 
                        setState(() {
                          _announcementScopes.clear();
                        });
                      }, 
                      textStyle: const TextStyle(fontSize: FontSize.base, color: Palette.secondary),
                      text: "Clear All",
                    ),
                  ]
                )
              ),
            ],
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<AnnouncementScope> teacherScopes = _announcementScopes.where((scope) => scope.scopeContext == "teachers").toList();
    final List<AnnouncementScope> studentScopes = _announcementScopes.where((scope) => scope.scopeContext == "students").toList();

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left_rounded,
            size: 32,
            color: Palette.body,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: Spacing.sm),
            child: PrimaryButton(height: 40, width: 120, text: "Publish", onPressed: () { print("done"); },),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: Spacing.lg, horizontal: Spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  maxLines: null,
                  controller: _titleController,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: FontSize.lg, color: Palette.gray400, fontWeight: FontWeight.w900),
                    hintText: "Announcement Title"
                  ),
                  style: const TextStyle(fontSize: FontSize.lg, color: Palette.heading, fontWeight: FontWeight.w900)
                ),
                const SizedBox(height: Spacing.md),
                const Divider(height: 2.0, color: Palette.gray200),
                const SizedBox(height: Spacing.md),
                const Text("SELECT AUDIENCE",
                    style: TextStyle(
                        color: Palette.subtitle,
                        fontSize: FontSize.sm,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: Spacing.md),
                ScopeSelectorMenu(
                    onChange: (data) {
                      setState(() {
                        _announcementScopes = data;
                      });
                    },
                  ),

                const SizedBox(height: Spacing.md),
                if (teacherScopes.isNotEmpty)
                  ScopeSection(
                    title: "TEACHERS",
                    scopes: teacherScopes,
                  ),
                if (studentScopes.isNotEmpty)
                  ScopeSection(
                    title: "STUDENTS",
                    scopes: studentScopes,
                  ),
                (teacherScopes.isNotEmpty || studentScopes.isNotEmpty ? SizedBox(height: Spacing.md) : SizedBox.shrink()),
                const Divider(height: 2.0, color: Palette.gray200),
              ],
            ),
          ),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: Spacing.lg),
                  child: TextField(
                    maxLines: null,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                      hintText: "eg \"This is an announcement regarding...\"",
                      hintStyle: TextStyle(fontSize: FontSize.base, color: Palette.gray400),
                    ),
                    style: TextStyle(fontSize: FontSize.base, color: Palette.body)
                  ),
                ),
  

        ],
      ),
    );
  }
}


class ScopeSection extends StatelessWidget {
  final String title;
  final List<AnnouncementScope> scopes;

  const ScopeSection({required this.title, required this.scopes, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Palette.subtitle, fontSize: FontSize.sm, fontWeight: FontWeight.bold)),
        const SizedBox(height: Spacing.sm),
        Wrap(
          spacing: Spacing.sm,
          runSpacing: Spacing.sm,
          children: scopes.map((scope) {
            return CustomChip(
              trailingIcon: const Icon(Icons.close, size: Widths.xs, color: Colors.black),
              text: scope.filterContent ?? scope.scopeContext,
              variant: ChipVariant.filled,
              color: Palette.bgSecondary,
              textColor: Colors.black,
            );
          }).toList(),
        ),
        const SizedBox(height: Spacing.md),
      ],
    );
  }
}
