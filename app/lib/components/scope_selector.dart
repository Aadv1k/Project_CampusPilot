import 'package:app/utils/colors.dart';
import 'package:app/utils/sizes.dart';
import 'package:flutter/material.dart';


class ScopeStructure {
  ScopeStructure({
    required this.value,
    required this.userReadable,
    this.children = const [],
  });

  String value;
  String userReadable;
  List<ScopeStructure> children;
}

final baseStructure = [
  ScopeStructure(
    value: "students",
    userReadable: "Students",
    children: [
      ScopeStructure(
        value: "8",
        userReadable: "8th Grade",
        children: [
          ScopeStructure(value: "8A", userReadable: "A", children: []),
          ScopeStructure(value: "8B", userReadable: "B", children: []),
          ScopeStructure(value: "8C", userReadable: "C", children: []),
        ],
      ),
      ScopeStructure(
        value: "9",
        userReadable: "9th Grade",
        children: [
          ScopeStructure(value: "9A", userReadable: "A", children: []),
          ScopeStructure(value: "9B", userReadable: "B", children: []),
          ScopeStructure(value: "9C", userReadable: "C", children: []),
        ],
      ),
      ScopeStructure(
        value: "10",
        userReadable: "10th Grade",
        children: [
          ScopeStructure(value: "10A", userReadable: "A", children: []),
          ScopeStructure(value: "10B", userReadable: "B", children: []),
          ScopeStructure(value: "10C", userReadable: "C", children: []),
        ],
      ),
    ],
  ),
  ScopeStructure(
    value: "teachers",
    userReadable: "Teachers",
    children: [
      ScopeStructure(
        value: "math",
        userReadable: "Math Department",
        children: [
          ScopeStructure(value: "algebra", userReadable: "Algebra", children: []),
          ScopeStructure(value: "geometry", userReadable: "Geometry", children: []),
          ScopeStructure(value: "calculus", userReadable: "Calculus", children: []),
        ],
      ),
      ScopeStructure(
        value: "science",
        userReadable: "Science Department",
        children: [
          ScopeStructure(value: "physics", userReadable: "Physics", children: []),
          ScopeStructure(value: "chemistry", userReadable: "Chemistry", children: []),
          ScopeStructure(value: "biology", userReadable: "Biology", children: []),
        ],
      ),
      ScopeStructure(
        value: "languages",
        userReadable: "Languages Department",
        children: [
          ScopeStructure(value: "english", userReadable: "English", children: []),
          ScopeStructure(value: "spanish", userReadable: "Spanish", children: []),
          ScopeStructure(value: "french", userReadable: "French", children: []),
        ],
      ),
    ],
  ),
];

class ScopeSelector extends StatefulWidget {
  const ScopeSelector({
    Key? key,
  }) : super(key: key);

  @override
  State<ScopeSelector> createState() => _ScopeSelectorState();
}

class _ScopeSelectorState extends State<ScopeSelector> {
  List<Widget> openedColumns = [Column(), Column(), Column()];

  @override
  void initState() {
    super.initState();
    openedColumns[0] = Column(
      children: _genericStructureBuilder(baseStructure, (value) {
        var second = baseStructure.firstWhere((elem) => elem.value == value);
        setState(() {
          openedColumns[1] = Column(
            children: _genericStructureBuilder(second.children, (childValue) {
              var third = second.children.firstWhere((elem) => elem.value == childValue);
              setState(() {
                openedColumns[2] = Column(
                  children: _genericStructureBuilder(third.children, (grandChildValue) {})
                );
              });
            })
          );
        });
      }),
    );


  }

  List<Widget> _genericStructureBuilder(List<dynamic> structure, Function(String) onTap) {
    List<Widget> genericWidgetList = [];

    for (var elem in structure) {
      genericWidgetList.add(
        ScopeSelectorItem(text: elem.userReadable, onTap: () => onTap(elem.value), onLongPress: () {}),
      );
    }

    return genericWidgetList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      decoration: BoxDecoration(
        color: Palette.offWhite100,
        border: Border.all(color: Palette.slate200, width: 1),
        borderRadius: BorderRadius.circular(Radii.sm),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: openedColumns.map((column) {
          return Expanded(
            child: Container(
              decoration: const BoxDecoration(border: Border(right: BorderSide(color: Palette.slate300, width: 1))),
              child: SingleChildScrollView(child: column),
            ),
          );
        }).toList(),
      ),
    );
  }
}


class ScopeSelectorItem extends StatelessWidget {
  const ScopeSelectorItem({required this.text, super.key, this.active, required this.onTap, required this.onLongPress});

  final String text;
  final bool? active;

  final Function() onTap;
  final Function() onLongPress;

  final double _accentBorderSize = 5;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Container(
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
      ),
    );
  }
}