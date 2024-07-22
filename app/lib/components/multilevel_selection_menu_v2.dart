import 'package:app/utils/colors.dart';
import 'package:app/utils/sizes.dart';
import 'package:flutter/material.dart';

enum MenuElementSelection {
  all,
  some,
  none
}

class MenuElement {
  const MenuElement({
    required this.id,
    required this.label,
    required this.level,
    required this.active,
    required this.selected,
  });

  final String id;
  final String label;
  final int level;
  final bool active;
  final MenuElementSelection selected;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MenuElement &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  static List<MenuElement> getChildrenOfElementById(List<MenuElement> elements, String id, {int? level}) {
    return elements.where((elem) {
      bool startsWithId = elem.id.startsWith(id) && elem.id != id;
      bool matchesLevel = true;
      if (level != null) {
        matchesLevel = '.'.allMatches(elem.id).length == level;
      }
      return startsWithId && matchesLevel;
    }).toList();
  }

  @override
  String toString() {
    return 'MenuElement(id: $id, label: $label)';
  }

  MenuElement copyWith({
    String? id,
    String? label,
    int? level,
    bool? active,
    MenuElementSelection? selected,
  }) {
    return MenuElement(
      id: id ?? this.id,
      label: label ?? this.label,
      level: level ?? this.level,
      active: active ?? this.active,
      selected: selected ?? this.selected,
    );
  }

}



class MenuStructure {
  MenuStructure({
    required this.id,
    required this.label,
    this.children = const [],
  });

  @override
  String toString() => "MenuStructure($label)";

  final String id;
  final String label;
  final List<MenuStructure> children;
}

List<MenuElement> buildMenuElementTreeFromStructure(MenuStructure structure, String topLevelId, int topLevel) {
  List<MenuElement> builtElements = [];

  final newId = topLevelId.isEmpty ? structure.id : "$topLevelId.${structure.id}";

  builtElements.add(MenuElement(
    id: newId,
    label: structure.label,
    level: topLevel,
    active: false,
    selected: MenuElementSelection.none,
  ));

  for (var child in structure.children) {
    builtElements.addAll(buildMenuElementTreeFromStructure(child, newId, topLevel + 1));
  }

  return builtElements;
}

class MultiLevelSelectionMenuV2 extends StatefulWidget {
  const MultiLevelSelectionMenuV2({
    super.key,
    required this.structure,
    required this.onChange,
    required this.menuItemWidgetBuilder,
    required this.hierarchyLevel,
    this.menuColumnDecoration,
    this.menuBoxDecoration,
    this.initiallyActiveKeys,
    this.height,
    this.width,
  });

  final List<MenuStructure> structure;
  final Function(List<MenuElement>) onChange;
  final Widget Function(
      String id,
      String label,
      VoidCallback onActiveChange,
      Function(bool) onSelectChange,
      MenuElementSelection selected,
      bool active,
    ) menuItemWidgetBuilder;
  final List<String>? initiallyActiveKeys;
  final int hierarchyLevel;
  final double? height;
  final double? width;
  final BoxDecoration? menuColumnDecoration;
  final BoxDecoration? menuBoxDecoration;

  @override
  State<MultiLevelSelectionMenuV2> createState() => _MultiLevelSelectionMenuV2State();
}

class _MultiLevelSelectionMenuV2State extends State<MultiLevelSelectionMenuV2> {
  List<MenuElement> elementData = [];
  List<(String, int)> expandedColumns = [];
  List<MenuElement> currentMenuState = [];
  List<MenuElement> activeMenuElements = [];

  @override
  void initState() {
    super.initState();
    elementData = widget.structure.map((elem) => buildMenuElementTreeFromStructure(elem, "root", 1)).expand((i) => i).toList();


    elementData.map((element) {
     var anySelected = MenuElement.getChildrenOfElementById(elementData, element.id).any((e) => e.selected != MenuElementSelection.none);

     if (anySelected) {
      return element.copyWith(selected: MenuElementSelection.some);
     }

     return element;

    });

    expandedColumns = [("root", 1)];
  }

  void _renderChildrenOfElement(MenuElement element) {
    setState(() {
      expandedColumns = expandedColumns.sublist(0, element.level);
      expandedColumns.add((element.id, element.level + 1));
    });
  }

  void _removeColumnsAfterLevel(int level)  {
    setState(() {
      expandedColumns = expandedColumns.sublist(0, level);
    });
  }

  void _removeChildrenOfElement(MenuElement element) {
    _removeColumnsAfterLevel(element.level);
  }

  void _updateMenuElementData(MenuElement element) {
      setState(() {
        var elemIndex = elementData.indexOf(element);
        elementData[elemIndex] = element;
      });
  }

  void _selectAllChildren(MenuElement element) {
    MenuElement.getChildrenOfElementById(elementData, element.id).forEach(
      (elem) => _updateMenuElementData(elem.copyWith(selected: MenuElementSelection.all))
    );
  }

  void _deselectAllChildren(MenuElement element) {
    MenuElement.getChildrenOfElementById(elementData, element.id).forEach(
      (elem) => _updateMenuElementData(elem.copyWith(selected: MenuElementSelection.none))
    );
  }


  Widget _buildMenuElementWidget(MenuElement element) {
    var elementChildren = MenuElement.getChildrenOfElementById(elementData, element.id);

    void onActiveChange() {
      if (element.active) {
        if (elementChildren.isEmpty) {
          return;
        }
        _renderChildrenOfElement(element);
        _updateMenuElementData(element.copyWith(active: true));
        elementData
            .where((elem) => elem.id != element.id && elem.level == element.level)
            .forEach((curElem) => _updateMenuElementData(curElem.copyWith(active: false)));
      } else {
        if (elementChildren.isEmpty) {
          _updateMenuElementData(element.copyWith(active: false));
          return;
        }
        _removeChildrenOfElement(element);
        _updateMenuElementData(element.copyWith(active: false));
      }
    }

    void onSelectionChange(bool? value) {
      switch (element.selected) {
        case MenuElementSelection.all:
          assert(elementChildren.isEmpty, "UNREACHABLE: selection can only be set to MenuElementSelection.some if element has children");
          _updateMenuElementData(element.copyWith(selected: MenuElementSelection.none));
          break;
        case MenuElementSelection.some:
          _updateMenuElementData(element.copyWith(selected: MenuElementSelection.none));
          elementChildren.forEach((elem) => _updateMenuElementData(elem.copyWith(selected: MenuElementSelection.none)));
          break;
        case MenuElementSelection.none:
          if (elementChildren.isEmpty) {
            _updateMenuElementData(element.copyWith(selected: MenuElementSelection.all));
          } else {
            _updateMenuElementData(element.copyWith(selected: MenuElementSelection.some));
            elementChildren.forEach((elem) => _updateMenuElementData(elem.copyWith(selected: MenuElementSelection.all)));
          }
          break;
        default:
          assert(false, "Unreachable");
      } 
    }

    return widget.menuItemWidgetBuilder(
      element.id,
      element.label,
      onActiveChange,
      onSelectionChange,
      element.selected,
      element.active,
    );
  }


  List<Widget> _buildMenuState() {
    List<Widget> columns = [];
    for (var expandedColData in expandedColumns) {
      columns.add(
      Expanded(
        child: Container(
          height: double.infinity,
          decoration: widget.menuColumnDecoration ??  BoxDecoration(
            border: Border(
              right: BorderSide(
                color: Colors.grey.shade400,
                width: 2,
              ),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: MenuElement.getChildrenOfElementById(elementData, expandedColData.$1, level: expandedColData.$2)
                  .map(_buildMenuElementWidget)
                  .toList(),
            ),
          ),
        ),
      ));
    }

    columns.addAll(List.generate(widget.hierarchyLevel - columns.length, (i) => const Expanded(child: Column())));

    return columns;
  }

  @override
  Widget build(BuildContext context) {
    var cols = _buildMenuState();
    cols.addAll(List.generate(
      widget.hierarchyLevel - cols.length,
      (index) => Expanded(child: Container()),
    ));

    return Container(
      height: widget.height ?? MediaQuery.of(context).size.height / 3,
      width: widget.width ?? double.infinity,
      decoration: widget.menuBoxDecoration ?? BoxDecoration(
        color: Colors.grey.shade300,
        border: Border.all(color: Colors.grey.shade400, width: 1),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: cols),
    );
  }
}
