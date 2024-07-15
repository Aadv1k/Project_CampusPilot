import 'package:app/utils/colors.dart';
import 'package:app/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'dart:collection';

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

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

class MenuStructure {
  MenuStructure({
    required this.value,
    required this.key,
    this.children = const [],
  });

  String value;
  String key;
  List<MenuStructure> children;
}

final baseStructure = [
  MenuStructure(
    value: "students",
    key: "Students",
    children: [
      MenuStructure(value: "8A", key: "8A", children: []),
      MenuStructure(value: "8B", key: "8B", children: []),
      MenuStructure(value: "8C", key: "8C", children: []),
      MenuStructure(value: "9A", key: "9A", children: []),
      MenuStructure(value: "9B", key: "9B", children: []),
      MenuStructure(value: "9C", key: "9C", children: []),
      MenuStructure(value: "10A", key: "10A", children: []),
      MenuStructure(value: "10B", key: "10B", children: []),
      MenuStructure(value: "10C", key: "10C", children: []),
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

class MenuElement {
  const MenuElement(
      {required this.key,
      required this.value,
      required this.level,
      this.childrenRef});

  final String value;
  final String key;
  final int level;
  final UnmodifiableListView<MenuStructure>? childrenRef;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final MenuElement otherElement = other as MenuElement;
    return level == otherElement.level && key == otherElement.key;
  }

  @override
  int get hashCode => Object.hash(level, key);
}

class ScopeSelector extends StatefulWidget {
  const ScopeSelector({Key? key}) : super(key: key);

  @override
  State<ScopeSelector> createState() => _ScopeSelectorState();
}

class _ScopeSelectorState extends State<ScopeSelector> {
  static const int hierarchyLevel = 2;

  List<List<MenuElement>> currentMenuState = [];
  List<MenuElement> activeMenuChildren = [];

  @override
  void initState() {
    super.initState();
    currentMenuState.add(menuElementFromMenuStructure(baseStructure, 0));
  }

  List<MenuElement> menuElementFromMenuStructure(
      List<MenuStructure> structure, int level) {
    return structure
        .map((e) => MenuElement(
            value: e.value,
            key: e.key,
            level: level,
            childrenRef: UnmodifiableListView(e.children)))
        .toList();
  }

  List<MenuElement> getChildrenOfMenuElement(MenuElement element) {
    return element.childrenRef
            ?.map((e) => MenuElement(
                value: e.value,
                key: e.key,
                level: element.level + 1,
                childrenRef: UnmodifiableListView(e.children)))
            .toList() ??
        [];
  }

  void _renderChildrenOfElement(MenuElement child) {
    setState(() {
      var children = getChildrenOfMenuElement(child);
      if (children.isEmpty) {
        return;
      }

      currentMenuState.add(children);

    });
  }

  void _collapseAllOtherColumns(MenuElement child) {
    setState(() {
      currentMenuState = currentMenuState.sublist(0, child.level + 1);
    });
  }

  void _removeActiveElement(MenuElement child) {
    setState(() {
      activeMenuChildren.removeWhere((elem) => elem == child);
    });
  }

  void _addActiveElement(MenuElement element) {
    setState(() {
      activeMenuChildren.add(element);
    });
  }

  Widget _buildMenuElementWidget(MenuElement element) {
    var children = getChildrenOfMenuElement(element);
    var hasChildren = children.isNotEmpty;
    var isActive = activeMenuChildren.contains(element);

    onTapAction() {
      if (hasChildren) {
        if (element.level + 1 == currentMenuState.length) {
          _renderChildrenOfElement(element);
        } else {
          _collapseAllOtherColumns(element);
        }
      }

      if (!hasChildren) {
        if (isActive) {
          _removeActiveElement(element);
        } else {
          _addActiveElement(element);
        }
      }
    }

    onLongPressAction() {
      if (isActive && element.childrenRef!.isNotEmpty) {
        getChildrenOfMenuElement(element).forEach(_removeActiveElement);
        _removeActiveElement(element);
        return;
      }

      if (element.childrenRef!.isNotEmpty) {
        HapticFeedback.mediumImpact();

        _addActiveElement(element);
        getChildrenOfMenuElement(element).forEach(_addActiveElement);

        _collapseAllOtherColumns(element);
        _renderChildrenOfElement(element);
      }
    }

    return ScopeSelectorItem(
      text: element.key,
      onTap: onTapAction,
      onLongPress: onLongPressAction,
      isActive: isActive,
      noArrow: !hasChildren,
    );
  }

  List<Widget> _buildMenuState() {
    List<Widget> menuRepr = [];

    for (var i = 0; i < currentMenuState.length; i++) {
      final level = i;

      menuRepr.add(Expanded(
        child: Container(
          height: double.infinity,
          decoration: const BoxDecoration(
            border:
                Border(right: BorderSide(color: Palette.slate200, width: 2)),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: currentMenuState[level]
                  .map((menuElement) => _buildMenuElementWidget(menuElement))
                  .toList(),
            ),
          ),
        ),
      ));
    }

    return menuRepr;
  }

  @override
  Widget build(BuildContext context) {
    var cols = _buildMenuState();
    cols.addAll(List.generate(
      hierarchyLevel - cols.length,
      (index) => Expanded(child: Container()),
    ));

    return Container(
      height: MediaQuery.of(context).size.height / 3,
      width: double.infinity,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Palette.offWhite100,
        border: Border.all(color: Palette.slate200, width: 1),
        borderRadius: BorderRadius.circular(Radii.sm),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: cols),
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
  final Function() onTap;
  final Function() onLongPress;
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