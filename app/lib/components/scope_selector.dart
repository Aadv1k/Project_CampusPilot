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


/*

students
  -> standard
  -> standard_division 
teachers
  -> departments
    -> Math
    -> Science
    -> PE
*/

final baseStructure = [
  MenuStructure(
    value: "Students",
    key: "students",
    children: [
      MenuStructure(value: "6th", key: "students.standard.6", children: [
        MenuStructure(value: "6A", key: "students.standard_division.6a", children: []),
        MenuStructure(value: "6B", key: "students.standard_division.6b", children: []),
        MenuStructure(value: "6C", key: "students.standard_division.6c", children: []),
        MenuStructure(value: "6D", key: "students.standard_division.6d", children: []),
      ]),
    ],
  ),
  MenuStructure(
    value: "Teachers",
    key: "teachers",
    children: [
      MenuStructure(value: "Departments", key: "teachers.department", children: [
        MenuStructure(key: "teachers.department.maths", value: "Maths", children: []),
        MenuStructure(key: "teachers.department.science", value: "Science", children: []),
        MenuStructure(key: "teachers.department.infotech", value: "Infotech", children: []),
        MenuStructure(key: "teachers.department.languages", value: "Languages", children: []),
        MenuStructure(key: "teachers.department.history", value: "History", children: []),
        MenuStructure(key: "teachers.department.arts", value: "Arts", children: []),
        MenuStructure(key: "teachers.department.physical", value: "Physical", children: []),
        MenuStructure(key: "teachers.department.music", value: "Music", children: []),
        MenuStructure(key: "teachers.department.geography", value: "Geography", children: []),
        MenuStructure(key: "teachers.department.economics", value: "Economics", children: []),
        MenuStructure(key: "teachers.department.other", value: "Other", children: []),
      ]),
    ],
  ),
];

List<AnnouncementScope> serializeMenuElementsToScopeData(List<MenuElement> activeElements) {
  List<AnnouncementScope> announcementScopes = [];

  List<String> addedParentId = [];

  for (var element in activeElements) {
    List<String> bits = element.key.split(".");

    if (addedParentId.contains(bits[0])) {
      continue;
    }

    if (bits.length == 1) {
      addedParentId.add(bits[0]);
      announcementScopes.add(AnnouncementScope(scopeContext: bits[0]));
    } else if (bits.length == 3) {
      addedParentId.add(bits[1]);
      announcementScopes.add(AnnouncementScope(scopeContext: bits[0], filterType:  bits[1], filterContent:  bits[2]));
    }
  }
  return announcementScopes;
}


class ScopeSelectorMenu extends StatelessWidget {
  final Function(List<AnnouncementScope>) onChange;

  final List<AnnouncementScope>? defaultActive;

  const ScopeSelectorMenu({this.defaultActive, required this.onChange, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiLevelSelectionMenu(
      structure: baseStructure,
      initiallyActiveKeys: defaultActive != null
        ? defaultActive!.map((elem) {
            final parts = [
              elem.scopeContext,
              if (elem.filterType != null && elem.filterType!.isNotEmpty) elem.filterType,
              if (elem.filterContent != null && elem.filterContent!.isNotEmpty) elem.filterContent,
            ];
            return parts.where((part) => part != null && part.isNotEmpty).join('.');
          }).toList()
        : [],


      height: MediaQuery.sizeOf(context).height / 3,
      menuBoxDecoration: BoxDecoration(
        color: Palette.gray100,
        border: Border.all(color: Palette.gray200, width: 1),
      ),
      menuColumnDecoration: const BoxDecoration(
        border: Border(right: BorderSide(color: Palette.gray200, width: 1)),
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
          left: Spacing.xs,
          right: Spacing.xs,
          top: Spacing.md,
          bottom: Spacing.md,
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
                  const SizedBox(width: Spacing.xs),
                  Expanded(
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: FontSize.xs,
                        color: Palette.gray700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (!noArrow)
              Container(
                margin: const EdgeInsets.only(right: Spacing.xs),
                child: const Icon(
                  Icons.chevron_right_rounded,
                  color: Palette.body,
                  size: Widths.xs,
                  grade: 1,
                ),
              ),
          ],
        ),
      ),
    );
  }
}