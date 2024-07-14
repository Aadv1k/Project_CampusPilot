import 'package:app/utils/colors.dart';
import 'package:app/utils/sizes.dart';
import 'package:flutter/material.dart';


/*



NestHiearchy 2

{ open: true, children: [{ open: false, }, ] }

true
  -> false
  -> false
  -> true
  -> false

Student
  -> 9th
    -> A, B, C, D, E
  -> 10th
    -> A, B, C
  -> 11th
    -> A, B
  -> 12th
    -> A
*/

// class ScopeStructure {
//   ScopeStructure({
//     required this.value,
//     required this.userReadable,
//     this.children = const [],
//   });

//   String value;
//   String userReadable;
//   List<ScopeStructure> children;
// }

// final baseStructure = [
//   ScopeStructure(
//     value: "students",
//     userReadable: "Students",
//     children: [
//       ScopeStructure(
//         value: "8",
//         userReadable: "8th Grade",
//         children: [
//           ScopeStructure(value: "8A", userReadable: "A", children: []),
//           ScopeStructure(value: "8B", userReadable: "B", children: []),
//           ScopeStructure(value: "8C", userReadable: "C", children: []),
//         ],
//       ),
//       ScopeStructure(
//         value: "9",
//         userReadable: "9th Grade",
//         children: [
//           ScopeStructure(value: "9A", userReadable: "A", children: []),
//           ScopeStructure(value: "9B", userReadable: "B", children: []),
//           ScopeStructure(value: "9C", userReadable: "C", children: []),
//         ],
//       ),
//       ScopeStructure(
//         value: "10",
//         userReadable: "10th Grade",
//         children: [
//           ScopeStructure(value: "10A", userReadable: "A", children: []),
//           ScopeStructure(value: "10B", userReadable: "B", children: []),
//           ScopeStructure(value: "10C", userReadable: "C", children: []),
//         ],
//       ),
//     ],
//   ),
//   ScopeStructure(
//     value: "teachers",
//     userReadable: "Teachers",
//     children: [
//       ScopeStructure(
//         value: "math",
//         userReadable: "Math Department",
//         children: [
//           ScopeStructure(value: "algebra", userReadable: "Algebra", children: []),
//           ScopeStructure(value: "geometry", userReadable: "Geometry", children: []),
//           ScopeStructure(value: "calculus", userReadable: "Calculus", children: []),
//         ],
//       ),
//       ScopeStructure(
//         value: "science",
//         userReadable: "Science Department",
//         children: [
//           ScopeStructure(value: "physics", userReadable: "Physics", children: []),
//           ScopeStructure(value: "chemistry", userReadable: "Chemistry", children: []),
//           ScopeStructure(value: "biology", userReadable: "Biology", children: []),
//         ],
//       ),
//       ScopeStructure(
//         value: "languages",
//         userReadable: "Languages Department",
//         children: [
//           ScopeStructure(value: "english", userReadable: "English", children: []),
//           ScopeStructure(value: "spanish", userReadable: "Spanish", children: []),
//           ScopeStructure(value: "french", userReadable: "French", children: []),
//         ],
//       ),
//     ],
//   ),
// ];

class MenuChild {
  const MenuChild({required this.value, required this.userReadable});

  final String value;
  final String userReadable;
}

class ScopeSelector extends StatefulWidget {
  const ScopeSelector({Key? key}) : super(key: key);

  @override
  State<ScopeSelector> createState() => _ScopeSelectorState();
}

class _ScopeSelectorState extends State<ScopeSelector> {
  static const int hierarchyLevel = 3;

  List<List<MenuChild>> currentMenuState = [];
  List<(int, String)> activeMenuChildren = [];

  @override
  void initState() { 
    super.initState();
    currentMenuState.add([
      const MenuChild(value: "student", userReadable: "Students"),
      const MenuChild(value: "teacher", userReadable: "Teachers"),
    ]);
  }

  void _handleMenuElementTap(int level, MenuChild child) { 
    setState(() {
      if (level == 0) {
        currentMenuState = [currentMenuState[0]];
        activeMenuChildren = activeMenuChildren.where((elem) => elem.$1 == level && elem.$2 == child.value).toList();
      } 
      activeMenuChildren.add((level, child.value));
    });

    if (level == 1) {
      return; // Hard-coded logic for level 1
    }

    setState(() {
      if (child.value == "teacher") {
        currentMenuState.add([
          const MenuChild(value: "department", userReadable: "Department"),
          const MenuChild(value: "subject", userReadable: "Subjects"),
        ]);
      } else {
        currentMenuState.add([
          const MenuChild(value: "9", userReadable: "9th"),
          const MenuChild(value: "8", userReadable: "8th"),
          const MenuChild(value: "7", userReadable: "7th"),
          const MenuChild(value: "6", userReadable: "6th"),
        ]);
      }
    });
  } 

  void _handleActiveMenuElementTap(int level, MenuChild child) { 
    setState(() {
      activeMenuChildren.remove((level, child.value));
      currentMenuState = currentMenuState.sublist(0, level + 1);
    });
  } 

  bool _isMenuItemActive(int level, MenuChild menuItem) {
    return activeMenuChildren.any((elem) => elem.$1 == level && elem.$2 == menuItem.value);
  }

  List<Widget> _buildMenuState() {
    List<Widget> menuRepr = [];

    for (var i = 0; i < currentMenuState.length; i++) {
      final level = i;

      menuRepr.add(Expanded(
        child: Container(
          decoration: const BoxDecoration(
            border: Border(right: BorderSide(color: Palette.slate200, width: 2)),
          ),
          child: Column(
            children: currentMenuState[level]
                .map((menuItem) => ScopeSelectorItem(
                      active: _isMenuItemActive(level, menuItem),
                      text: menuItem.userReadable,
                      onTap: () => _isMenuItemActive(level, menuItem) 
                          ? _handleActiveMenuElementTap(level, menuItem) 
                          : _handleMenuElementTap(level, menuItem),
                      onLongPress: () {},
                    ))
                .toList(),
          ),
        ),
      ));
    }

    return menuRepr;
  }

  @override
  Widget build(BuildContext context) {
    var cols = _buildMenuState();
    cols += List.filled(hierarchyLevel - cols.length, Expanded(child: Container()));

    return Container(
      height: MediaQuery.of(context).size.height / 3,
      width: double.infinity,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Palette.offWhite100,
        border: Border.all(color: Palette.slate200, width: 1),
        borderRadius: BorderRadius.circular(Radii.sm),
      ),
      child: Row(children: cols),
    );
  }
}

class ScopeSelectorItem extends StatelessWidget {
  const ScopeSelectorItem({
    required this.text,
    required this.onTap,
    required this.onLongPress,
    this.active,
    super.key,
  });

  final String text;
  final bool? active;
  final Function() onTap;
  final Function() onLongPress;

  static const double _accentBorderSize = 5;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: active == true ? Palette.lightBlue.withOpacity(0.3) : null,
          border: Border(
            left: BorderSide(color: active == true ? Palette.lightBlue : Colors.transparent, width: _accentBorderSize),
          ),
        ),
        padding: const EdgeInsets.only(left: Spacing.xs, right: Spacing.md, top: Spacing.lg, bottom: Spacing.lg),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: FontSize.sm, color: Palette.slate600),
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Palette.slate400, size: Widths.xs),
          ],
        ),
      ),
    );
  }
}
