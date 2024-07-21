import 'package:app/views/announcement_create_view.dart';
import 'package:flutter/material.dart';
import 'package:app/components/announcement_card.dart';
import 'package:app/components/button.dart';
import 'package:app/models/announcement.dart';
import 'package:app/utils/colors.dart';
import 'package:app/utils/sizes.dart';

class AnnouncementListView extends StatefulWidget {
  const AnnouncementListView({super.key});

  @override
  State<AnnouncementListView> createState() => _AnnouncementListViewState();
}

class _AnnouncementListViewState extends State<AnnouncementListView> {
  bool searchActive = false;
  bool isForYou = true;
  bool isLoading = false;
  bool forYouLoaded = false;
  bool yourAnnouncementsLoaded = false;

  List<Announcement> forYouAnnouncements = [];
  List<Announcement> yourAnnouncements = [];

  @override
  void initState() {
    super.initState();
    _loadAnnouncements(isForYou);
  }

  void _toggleSearchActive(bool to) {
    setState(() {
      searchActive = to;
    });
  }

  void _toggleTab(bool forYou) {
    setState(() {
      isForYou = forYou;
      if ((forYou && !forYouLoaded) || (!forYou && !yourAnnouncementsLoaded)) {
        isLoading = true;
        _loadAnnouncements(forYou);
      }
    });
  }

  void _loadAnnouncements(bool forYou) {
    // Simulate API call
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        if (forYou) {
          forYouLoaded = true;
          forYouAnnouncements = [
            Announcement(
              "c35d0c83-9130-40f0-a30c-a301224b0a90",
              "Revised schedule for I periodic assessment",
              "Dear Parents, \nKindly note the revised schedule for I Periodic Assessment / I Class Test for STD VI to X and STD XII to be held from 27/06/24 to 04/07/24\n",
              "Ms Anuradha",
              "2024-07-05T15:26:22.743Z",
            ),
            Announcement(
              "e15d1a92-12f2-4b6d-b21b-52e2173d9d81",
              "New Library Books Available",
              "We are pleased to inform you that new books have been added to the school library. Students are encouraged to explore and borrow the new arrivals.",
              "Mr Sharma",
              "2024-07-05T09:00:00.000Z",
            ),
          ];
        } else {
          yourAnnouncementsLoaded = true;
          yourAnnouncements = [
            Announcement(
              "f65a3b84-2f73-4956-9ef2-8e3f5f3e5f7b",
              "Parent-Teacher Meeting Schedule",
              "The next parent-teacher meeting is scheduled for July 10, 2024. Please ensure your presence to discuss your child's progress.",
              "Ms Kavita",
              "2024-07-05T10:00:00.000Z",
            ),
            Announcement(
              "g12c4d55-5f4c-4a2d-94c6-7a9e3d3e5a6a",
              "Sports Day Postponed",
              "Due to unforeseen weather conditions, the Sports Day event has been postponed to July 20, 2024. We apologize for any inconvenience caused.",
              "Mr Ramesh",
              "2024-07-05T11:00:00.000Z",
            ),
          ];
        }
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchActive 
        ? SearchAppBar(onBack: () => _toggleSearchActive(false)) 
        : const MainAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchBar(onTap: () => _toggleSearchActive(true), active: searchActive),
          searchActive 
            ? Container(
                decoration: const BoxDecoration(
                  color: Palette.bgSecondary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(Radii.xxl),
                    bottomRight: Radius.circular(Radii.xxl)
                  ),
                ),
              ) 
            : TabControl(
                isForYou: isForYou,
                onTabChange: _toggleTab,
              ),
          Expanded(
            child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : (isForYou && !forYouLoaded) || (!isForYou && !yourAnnouncementsLoaded)
                ? const Center(child: Text("No data available"))
                : ListView.builder(
                    itemCount: isForYou ? forYouAnnouncements.length : yourAnnouncements.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final announcement = isForYou ? forYouAnnouncements[index] : yourAnnouncements[index];
                      return AnnouncementCard(
                        announcement.id,
                        announcement.title,
                        announcement.body,
                        announcement.authorName,
                        announcement.postedAt,
                      );
                    },
                  ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          Navigator.push(context, 
            MaterialPageRoute(builder: (context) => const AnnouncementCreateView()),
          );
        },
        backgroundColor: Palette.primary,
        child: const Icon(Icons.add, size: Widths.lg, color: Colors.white),
      ),
    );
  }
}

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBack;

  const SearchAppBar({required this.onBack, super.key});

  @override
  Size get preferredSize => const Size.fromHeight(Heights.lg);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0.0,
      backgroundColor: Palette.bgSecondary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: onBack,
      ),
    );
  }
}

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(Heights.xl);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: Heights.xl,
      centerTitle: true,
      title: const Text(
        "Announcements",
        style: TextStyle(
          color: Palette.slate900,
          fontWeight: FontWeight.bold,
          fontSize: FontSize.lg,
        ),
      ),
      backgroundColor: Palette.white,
    );
  }
}

class TabControl extends StatelessWidget {
  final bool isForYou;
  final Function(bool) onTabChange;

  const TabControl({required this.isForYou, required this.onTabChange, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.md),
      child: Row(children: [
        TabButton("For You", isForYou, () => onTabChange(true)),
        const SizedBox(width: Spacing.sm),
        TabButton("Your Announcements", !isForYou, () => onTabChange(false))
      ]),
    );
  }
}

class TabButton extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const TabButton(this.text, this.selected, this.onTap, {super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        height: Heights.lg,
        decoration: BoxDecoration(
          border: Border.all(color: Palette.slate950, width: 1.0),
          color: selected ? Palette.slate950 : null,
          borderRadius: BorderRadius.circular(Radii.xl),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(Radii.xl),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
            child: Center(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: FontSize.base,
                  color: selected ? Palette.slate100 : Palette.slate950,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final VoidCallback onTap;
  final bool active;

  const SearchBar({required this.onTap, this.active = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: active ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: Spacing.md),
      padding: const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.sm),
      height: !active ? Heights.xl : Heights.xxl,
      decoration: BoxDecoration(
        color: Palette.bgSecondary,
        borderRadius: active ? null : const BorderRadius.all(Radius.circular(Radii.xl)),
        border: !active ? Border.all(color: Palette.slate200, width: 1.0) : null,
      ),
      child: active
        ? const TextField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Search Announcements...',
              hintStyle: TextStyle(
                color: Palette.slate600,
                fontSize: FontSize.base,
              ),
              border: InputBorder.none,
            ),
            style: TextStyle(color: Palette.slate800, fontSize: FontSize.base),
          )
        : GestureDetector(
            onTap: onTap,
            child: const Row(
              children: [
                Icon(Icons.search, color: Palette.slate400, size: Widths.md),
                SizedBox(width: Spacing.sm),
                Text(
                  'Search Announcements...',
                  style: TextStyle(
                    color: Palette.slate600,
                    fontSize: FontSize.base,
                  ),
                ),
              ],
            ),
          ),
    );
  }
}