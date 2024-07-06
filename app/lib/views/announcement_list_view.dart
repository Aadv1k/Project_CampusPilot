import 'package:app/components/announcement_card.dart';
import 'package:app/components/safe_scaffold.dart';
import 'package:app/components/typography.dart';
import 'package:app/models/announcement.dart';
import 'package:app/utils/colors.dart';
import 'package:app/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AnnouncementListView extends StatefulWidget {
  const AnnouncementListView({super.key, });

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
  late bool searchActive;

  _AnnouncementListViewState() {
    searchActive = searchText.trim().isEmpty;
  }

  void _handleSearchInput(String text) {
    setState(() {
      searchText = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Announcement> filteredData = searchActive
        ? data.where((announcement) => announcement.body.toLowerCase().contains(searchText.toLowerCase())).toList()
        : data;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Announcements", style: TextStyle(color: Palette.gray800, fontWeight: FontWeight.bold, fontSize: FontSize.xxl)),
        backgroundColor: Palette.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.sm),
                      decoration: const BoxDecoration(
                        color: Palette.gray200,
                        borderRadius: BorderRadius.all(Radius.circular(16))
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center, 
                        children: [
                          const Icon(Icons.search, color: Palette.gray400, size: 28),
                          const SizedBox(width: Spacing.sm),
                          Expanded(
                            child: TextField(
                                decoration: const InputDecoration(
                                  hintText: 'Search announcements...',
                                  hintStyle: TextStyle(color: Palette.gray400, fontSize: FontSize.md),
                                  border: InputBorder.none
                                ),
                                onChanged: _handleSearchInput,
                              ),
                          ),
                        ],
                      ),
                    ),
                      const SizedBox(height: Spacing.md),
                  ],
                ),
              ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredData.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return AnnouncementCard(filteredData[index].id, filteredData[index].title, filteredData[index].body, filteredData[index].authorName, false);
                    }
                  ),
                )
             ],
              
             // Search Box
             // Control Bar
              
              
              ),
        ),
      )
    );
  }
}