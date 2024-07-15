import 'package:app/models/announcement.dart';
import 'package:flutter/material.dart';
import 'package:app/components/multilevel_selection_menu.dart';
import 'package:app/utils/colors.dart';
import 'package:app/utils/sizes.dart';

final baseStructure = [
  MenuStructure(
    value: "students",
    key: "Students",
    children: [
      MenuStructure(value: "8thGrade", key: "8th Grade", children: [
        MenuStructure(value: "8A", key: "8A", children: []),
        MenuStructure(value: "8B", key: "8B", children: []),
        MenuStructure(value: "8C", key: "8C", children: []),
      ]),
      MenuStructure(value: "9thGrade", key: "9th Grade", children: [
        MenuStructure(value: "9A", key: "9A", children: []),
        MenuStructure(value: "9B", key: "9B", children: []),
        MenuStructure(value: "9C", key: "9C", children: []),
      ]),
      MenuStructure(value: "10thGrade", key: "10th Grade", children: [
        MenuStructure(value: "10A", key: "10A", children: []),
        MenuStructure(value: "10B", key: "10B", children: []),
        MenuStructure(value: "10C", key: "10C", children: []),
      ]),
    ],
  ),
  MenuStructure(
    value: "teachers",
    key: "Teachers",
    children: [
      MenuStructure(value: "math", key: "Math Department", children: []),
      MenuStructure(value: "science", key: "Science Department", children: []),
      MenuStructure(value: "languages", key: "Languages Department", children: []),
    ],
  ),
];



List<AnnouncementScope> serializeMenuElementsToScopeData(List<MenuElement> activeElements) {
  return [];
}

class ScopeSelectorMenu extends StatelessWidget {
  const ScopeSelectorMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiLevelSelectionMenu(
      structure: baseStructure,
      height: MediaQuery.sizeOf(context).height / 2.5,
      menuBoxDecoration: BoxDecoration(
        color: Palette.offWhite100,
        border: Border.all(color: Palette.slate200, width: 2)
      ),
      menuColumnDecoration: const BoxDecoration(
        border: Border(right: BorderSide(color: Palette.slate200, width: 2))
      ),
      onChange: (elements) {
        print(elements.map((elem) => elem.key).toList());
      },
      menuItemWidgetBuilder: (text, onTap, onLongPress, isActive, noArrow) {
        return ScopeSelectorItem(
          text: text,
          onTap: onTap,
          onLongPress: onLongPress,
          isActive: isActive,
          noArrow: noArrow,
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
    Key? key,
  }) : super(key: key);

  final String text;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final bool noArrow;

  static const double _accentBorderSize = 2.5;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isActive ? Palette.lightBlue.withOpacity(0.3) : null,
          border: Border(
            left: BorderSide(
                color: isActive ? Palette.lightBlue : Colors.transparent,
                width: _accentBorderSize),
          ),
        ),
        padding: const EdgeInsets.only(
            left: Spacing.md,
            right: Spacing.md,
            top: Spacing.md,
            bottom: Spacing.md),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      text,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          fontSize: FontSize.sm, color: Palette.slate800),
                    ),
                  ),
                ],
              ),
            ),
            if (!noArrow)
              const Icon(Icons.chevron_right_rounded,
                  color: Palette.slate400, size: Widths.xs),
          ],
        ),
      ),
    );
  }
}