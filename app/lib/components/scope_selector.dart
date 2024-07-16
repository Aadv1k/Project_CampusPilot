import 'package:app/models/announcement.dart';
import 'package:flutter/material.dart';
import 'package:app/components/multilevel_selection_menu.dart';
import 'package:app/utils/colors.dart';
import 'package:app/utils/sizes.dart';

enum StudentGrade {
  grade6,
  grade7,
  grade8,
  grade9,
  grade10,
  grade11,
  grade12,
}

enum TeacherDepartment {
  maths,
  science,
  infotech,
  languages,
  history,
  arts,
  physicalEducation,
  music,
  geography,
  economics,
  other,
}

final baseStructure = [
  MenuStructure(
    value: "students",
    key: "students",
    children: [
      MenuStructure(value: StudentGrade.grade6.toString(), key: "students.6th_grade", children: [
        MenuStructure(value: "6A", key: "students.6th_grade.6a", children: []),
        MenuStructure(value: "6B", key: "students.6th_grade.6b", children: []),
        MenuStructure(value: "6C", key: "students.6th_grade.6c", children: []),
        MenuStructure(value: "6D", key: "students.6th_grade.6d", children: []),
      ]),
      MenuStructure(value: StudentGrade.grade7.toString(), key: "students.7th_grade", children: [
        MenuStructure(value: "7A", key: "students.7th_grade.7a", children: []),
        MenuStructure(value: "7B", key: "students.7th_grade.7b", children: []),
        MenuStructure(value: "7C", key: "students.7th_grade.7c", children: []),
        MenuStructure(value: "7D", key: "students.7th_grade.7d", children: []),
      ]),
      MenuStructure(value: StudentGrade.grade8.toString(), key: "students.8th_grade", children: [
        MenuStructure(value: "8A", key: "students.8th_grade.8a", children: []),
        MenuStructure(value: "8B", key: "students.8th_grade.8b", children: []),
        MenuStructure(value: "8C", key: "students.8th_grade.8c", children: []),
        MenuStructure(value: "8D", key: "students.8th_grade.8d", children: []),
      ]),
      MenuStructure(value: StudentGrade.grade9.toString(), key: "students.9th_grade", children: [
        MenuStructure(value: "9A", key: "students.9th_grade.9a", children: []),
        MenuStructure(value: "9B", key: "students.9th_grade.9b", children: []),
        MenuStructure(value: "9C", key: "students.9th_grade.9c", children: []),
        MenuStructure(value: "9D", key: "students.9th_grade.9d", children: []),
      ]),
      MenuStructure(value: StudentGrade.grade10.toString(), key: "students.10th_grade", children: [
        MenuStructure(value: "10A", key: "students.10th_grade.10a", children: []),
        MenuStructure(value: "10B", key: "students.10th_grade.10b", children: []),
        MenuStructure(value: "10C", key: "students.10th_grade.10c", children: []),
        MenuStructure(value: "10D", key: "students.10th_grade.10d", children: []),
      ]),
      MenuStructure(value: StudentGrade.grade11.toString(), key: "students.11th_grade", children: [
        MenuStructure(value: "11A", key: "students.11th_grade.11a", children: []),
        MenuStructure(value: "11B", key: "students.11th_grade.11b", children: []),
        MenuStructure(value: "11C", key: "students.11th_grade.11c", children: []),
        MenuStructure(value: "11D", key: "students.11th_grade.11d", children: []),
      ]),
      MenuStructure(value: StudentGrade.grade12.toString(), key: "students.12th_grade", children: [
        MenuStructure(value: "12A", key: "students.12th_grade.12a", children: []),
        MenuStructure(value: "12B", key: "students.12th_grade.12b", children: []),
        MenuStructure(value: "12C", key: "students.12th_grade.12c", children: []),
        MenuStructure(value: "12D", key: "students.12th_grade.12d", children: []),
      ]),
    ],
  ),
  MenuStructure(
    value: "teachers",
    key: "teachers",
    children: [
      MenuStructure(value: TeacherDepartment.maths.toString(), key: "teachers.maths_dept", children: []),
      MenuStructure(value: TeacherDepartment.science.toString(), key: "teachers.science_dept", children: []),
      MenuStructure(value: TeacherDepartment.infotech.toString(), key: "teachers.infotech_dept", children: []),
      MenuStructure(value: TeacherDepartment.languages.toString(), key: "teachers.languages_dept", children: []),
      MenuStructure(value: TeacherDepartment.history.toString(), key: "teachers.history_dept", children: []),
      MenuStructure(value: TeacherDepartment.arts.toString(), key: "teachers.arts_dept", children: []),
      MenuStructure(value: TeacherDepartment.physicalEducation.toString(), key: "teachers.physical_education_dept", children: []),
      MenuStructure(value: TeacherDepartment.music.toString(), key: "teachers.music_dept", children: []),
      MenuStructure(value: TeacherDepartment.geography.toString(), key: "teachers.geography_dept", children: []),
      MenuStructure(value: TeacherDepartment.economics.toString(), key: "teachers.economics_dept", children: []),
      MenuStructure(value: TeacherDepartment.other.toString(), key: "teachers.other_dept", children: []),
    ],
  ),
];



/* TODO: this function needs a lot of work */
List<AnnouncementScope> serializeMenuElementsToScopeData(List<MenuElement> activeElements) {
  List<AnnouncementScope> announcementScopes = [];

  for (var element in activeElements) {
    List<String> bits = element.key.split(".");
    String scopeContext = bits[0];
    String filterType = scopeContext == "students" ? "standard_division" : "department";
    String filterContent = element.value;

    announcementScopes.add(
      AnnouncementScope(
        scopeContext: scopeContext,
        filterType: filterType,
        filterContent: filterContent,
      ),
    );
  }



  return announcementScopes;
}


class ScopeSelectorMenu extends StatelessWidget {
  final Function(List<AnnouncementScope>) onChange;

  const ScopeSelectorMenu({required this.onChange, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiLevelSelectionMenu(
      structure: baseStructure,
      height: double.infinity,
      menuBoxDecoration: BoxDecoration(
        color: Palette.gray50,
        border: Border.all(color: Palette.gray100, width: 2),
      ),
      menuColumnDecoration: const BoxDecoration(
        border: Border(right: BorderSide(color: Palette.gray100, width: 2)),
      ),
      onChange: (elements) {
        List<AnnouncementScope> scopes = serializeMenuElementsToScopeData(elements);
        onChange(scopes);
      },
      menuItemWidgetBuilder: (text, onTap, onLongPress, isActive, noArrow, hasActiveChildren) {
        return ScopeSelectorItem(
          text: text,
          onTap: onTap,
          onLongPress: onLongPress,
          isActive: isActive,
          noArrow: noArrow,
          hasActiveChildren: hasActiveChildren,
        );
      },
      hierarchyLevel: 3,
    );
  }
}


class ScopeSelectorItem extends StatelessWidget {
  const ScopeSelectorItem({
    required this.text,
    required this.onTap,
    required this.onLongPress,
    required this.isActive,
    this.noArrow = false,
    this.hasActiveChildren = false,
    Key? key,
  }) : super(key: key);

  final String text;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final bool noArrow;
  final bool hasActiveChildren;

  static const double _accentBorderSize = 2.5;
  static const double _dotSize = 8;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isActive ? Colors.lightBlue.shade50 : null,
          border: Border(
            left: BorderSide(
              color: isActive ? Colors.lightBlue.shade400 : Colors.transparent,
              width: _accentBorderSize,
            ),
          ),
        ),
        padding: const EdgeInsets.only(
          left: Spacing.sm,
          right: Spacing.sm,
          top: Spacing.lg,
          bottom: Spacing.lg,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (hasActiveChildren)
                    Container(
                      width: _dotSize,
                      height: _dotSize,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue.shade400,
                        shape: BoxShape.circle,
                      ),
                      margin: const EdgeInsets.only(left: Spacing.xs),
                    ),
                  const SizedBox(width: Spacing.xs),
                  Expanded(
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: FontSize.sm,
                        color: Palette.gray700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (!noArrow)
              const Icon(
                Icons.chevron_right_rounded,
                color: Palette.body,
                size: Widths.xs,
                grade: 1,
              ),
          ],
        ),
      ),
    );
  }
}