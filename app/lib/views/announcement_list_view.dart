import 'package:app/components/announcement_card.dart';
import 'package:app/components/button.dart';
import 'package:app/models/announcement.dart';
import 'package:app/utils/colors.dart';
import 'package:app/utils/sizes.dart';
import 'package:flutter/material.dart';

class AnnouncementListView extends StatefulWidget {
  const AnnouncementListView({
    super.key,
  });

  @override
  State<AnnouncementListView> createState() => _AnnouncementListViewState();
}

List<Announcement> mockAnnouncementData = [
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
  Announcement(
    "h78e5e66-6f5d-4c3d-95d7-9a9f4f4e7a7b",
    "Annual Science Fair",
    "The Annual Science Fair will be held on July 25, 2024. Students are encouraged to participate and showcase their innovative projects.",
    "Dr. Mehta",
    "2024-07-05T12:00:00.000Z",
  ),
  Announcement(
    "i23f6f77-7f6e-4d4e-96e8-8b9e5f5e8b8c",
    "Exam Schedule Released",
    "The final exam schedule for all grades has been released. Please check the notice board or the school website for detailed information.",
    "Mrs. Patel",
    "2024-07-05T13:00:00.000Z",
  ),
  Announcement(
    "k45h9h99-4d8b-43e1-bc1f-6c6e3c3c5c5d",
    "New Extracurricular Activities",
    "New extracurricular activities, including music, dance, and painting classes, will begin from next month. Interested students, please enroll at the earliest.",
    "Ms. Ananya",
    "2024-07-06T15:00:00.000Z",
  ),
  Announcement(
    "l56i0i00-5a9f-47c2-bf1e-7b7f4b4b6b6e",
    "Upcoming Field Trip",
    "A field trip to the local botanical garden is scheduled for July 15, 2024. Permission slips will be distributed shortly.",
    "Mr. Varun",
    "2024-07-07T09:00:00.000Z",
  ),
  Announcement(
    "m67j1j11-6b0e-48d3-aa2d-8d8c5d5d7d7f",
    "Summer Vacation Notice",
    "Please note that the school will remain closed for summer vacation from July 30 to August 15, 2024. Classes will resume on August 16, 2024.",
    "Mrs. Sharma",
    "2024-07-07T10:00:00.000Z",
  ),
  Announcement(
    "n78k2k22-7c1f-49b4-bd3c-9e9d6e6e8e8g",
    "Community Service Project",
    "Students are encouraged to participate in a community service project to clean up the local park on July 12, 2024. Volunteers please register at the school office.",
    "Mr. Anand",
    "2024-07-07T11:00:00.000Z",
  ),
];

class _AnnouncementListViewState extends State<AnnouncementListView> {
  List<Announcement> data = mockAnnouncementData;
  String searchText = "";
  bool searchActive = false;
  DateTime _lastInputTime = DateTime.now();

  void _toggleSearchActive(bool to) {
    setState(() {
      searchActive = to;
    });
  }

  void _handleSearchInput(String? text) {
    if (text == null) return;

    final currentTime = DateTime.now();

    if (currentTime.difference(_lastInputTime) == const Duration(seconds: 2)) {
      setState(() {
        _lastInputTime = currentTime;
      });
      return;
    }

    setState(() {
      searchText = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: searchActive ? SearchAppBar(onBack: () => _toggleSearchActive(false)) : const MainAppBar(),

        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchBar(onInput: _handleSearchInput, onTap: ()  => _toggleSearchActive(true), active: searchActive,),
            
            // TODO: show search controls here as well, but that is too much work for now
            searchActive ?  Container(height: Heights.sm, decoration: const BoxDecoration(
              color: Palette.secondary,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40))
            ),) : const TabControl(),
            
            Expanded(
              child: ListView.builder(
                  itemCount: mockAnnouncementData.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return AnnouncementCard(
                        mockAnnouncementData[index].id,
                        mockAnnouncementData[index].title,
                        mockAnnouncementData[index].body,
                        mockAnnouncementData[index].authorName,
                        mockAnnouncementData[index].postedAt);
                  }),
            )
          ],
        ));
  }
}

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBack;

  const SearchAppBar({
    required this.onBack,
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(Heights.lg);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0.0,
      backgroundColor: Palette.secondary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: onBack,
      ),
    );
  }
}



class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(Heights.xl);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: Heights.xl,
      leading: IconButton(onPressed: () => {}, icon: const Icon(Icons.menu)),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
          child: UserProfileButton(
            profileInitials: "AP",
            size: Widths.lg,
          ),
        ),
      ],
      centerTitle: true,
      title: const Text(
        "Announcements",
        style: TextStyle(
            color: Palette.slate900,
            fontWeight: FontWeight.bold,
            fontSize: FontSize.lg),
      ),
      backgroundColor: Palette.white,
    );
  }
}

class SearchChip extends StatelessWidget {
  final String text;
  final bool isActive;

  const SearchChip({
    required this.text,
    this.isActive = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color? fillColor = isActive ? Palette.primary : Palette.secondary;
    Color? textColor = isActive ? Palette.slate100 : Palette.primary;

    return ActionChip(
      backgroundColor: fillColor,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Palette.gray950),
        borderRadius: BorderRadius.circular(Radii.xl),
      ),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text, style: TextStyle(color: textColor, fontSize: FontSize.sm)),
          const SizedBox(width: Spacing.sm),
          !isActive 
            ? const Icon(Icons.arrow_drop_down, color: Palette.slate800, size: Widths.sm) 
            : const SizedBox(height: Widths.sm),
    
        ],
      ),
      onPressed: () {
        // Handle chip press event
      },
    );
  }
}

class SearchControl extends StatelessWidget {
  const SearchControl({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.md),
      decoration: const BoxDecoration(
        color: Palette.secondary,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35), bottomRight: Radius.circular(35))
      ),
      child: const Row(children: [
        SearchChip(text: "Posted By", isActive: false),
        SizedBox(width: Spacing.sm),
        SearchChip(text: "Date"),
      ]),
    );
  }
}

class TabControl extends StatelessWidget {
  const TabControl({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.md),
      child: Row(children: [
        TabButton("For You", true, () => {}),
        const SizedBox(width: Spacing.sm),
        TabButton("Your Announcements", false, () => {})
      ]),
    );
  }
}

class TabButton extends StatelessWidget {
  const TabButton(this.text, this.selected, this.onTap, {super.key});

  final String text;
  final bool selected;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          height: Heights.lg,
          decoration: BoxDecoration(
              border: Border.all(color: Palette.slate950, width: 1.0),
              color: selected ? Palette.slate950 : null,
              borderRadius: BorderRadius.circular(Radii.xl)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
            child: Center(
                child: Text(text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: FontSize.base,
                        color:
                            selected ? Palette.slate100 : Palette.slate950))),
          )),
    );
  }
}

class SearchBar extends StatefulWidget {
  final Function(String?) onInput;
  final Function() onTap;
  final bool active;

  const SearchBar({
    required this.onInput,
    required this.onTap,
    this.active = false,
    super.key,
  });

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late FocusNode _focusNode;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _controller = TextEditingController();

    _controller.addListener(() {
      final String searchText = _controller.text.toLowerCase();
      widget.onInput(searchText);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.active ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: Spacing.md),
      padding: const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.sm),
      decoration: BoxDecoration(
        color: Palette.secondary,
        borderRadius: widget.active ? null : const BorderRadius.all(Radius.circular(Radii.xl)),
        border: !widget.active ? Border.all(color: Palette.slate200, width: 1.0) : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          widget.active ? const SizedBox.shrink() : const Icon(Icons.search, color: Palette.slate400, size: Widths.md),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: GestureDetector(
              onTap: () {
                widget.onTap();
              },
              child: TextField(
                enabled: widget.active,
                focusNode: _focusNode,
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Search Announcements...',
                  hintStyle: TextStyle(
                    color: Palette.slate600,
                    fontSize: FontSize.base,
                  ),
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Palette.slate800, fontSize: FontSize.md),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
