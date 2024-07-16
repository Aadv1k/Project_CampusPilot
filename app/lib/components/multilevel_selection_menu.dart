import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

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

class MenuElement {
  const MenuElement({
    required this.key,
    required this.value,
    required this.level,
    this.childrenRef,
  });

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

class MultiLevelSelectionMenu extends StatefulWidget {
  const MultiLevelSelectionMenu({
    super.key,
    required this.structure,
    required this.onChange,
    required this.menuItemWidgetBuilder,
    required this.hierarchyLevel,

    this.menuColumnDecoration,
    this.menuBoxDecoration,

    this.height,
    this.width,
  });

  final List<MenuStructure> structure;
  final Function(List<MenuElement>) onChange;

  final Widget Function(
      String text,
      VoidCallback onTap,
      VoidCallback onLongPress,
      bool isActive,
      bool noArrow,
      bool hasActiveChildren
    ) menuItemWidgetBuilder;

  final int hierarchyLevel;
  final double? height;
  final double? width;

  final BoxDecoration? menuColumnDecoration;
  final BoxDecoration? menuBoxDecoration;

  @override
  State<MultiLevelSelectionMenu> createState() =>
      _MultiLevelSelectionMenuState();
}

class _MultiLevelSelectionMenuState extends State<MultiLevelSelectionMenu> {
  MenuElement? _currentlyOpenedElement;

  List<List<MenuElement>> currentMenuState = [];
  List<MenuElement> activeMenuChildren = [];

  @override
  void initState() {
    super.initState();
    currentMenuState.add(menuElementFromMenuStructure(widget.structure, 0));
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
      widget.onChange(activeMenuChildren);
    });
  }

  void _addActiveElement(MenuElement element) {
    setState(() {
      activeMenuChildren.add(element);
      widget.onChange(activeMenuChildren);
    });
  }

  void _recursivelyActivateEveryChildOfElement(MenuElement element) {
    _addActiveElement(element);
    getChildrenOfMenuElement(element)
        .forEach(_recursivelyActivateEveryChildOfElement);
  }

  void _recursivelyDeactivateEveryChildOfElement(MenuElement element) {
    _removeActiveElement(element);
    getChildrenOfMenuElement(element)
        .forEach(_recursivelyDeactivateEveryChildOfElement);
  }

  Widget _buildMenuElementWidget(MenuElement element) {
    var children = getChildrenOfMenuElement(element);
    var hasChildren = children.isNotEmpty;
    var isActive = activeMenuChildren.contains(element);

    onTapAction() {
      // If it has children, then it is a "level/sub-level" in this case
      // we won't make it active, but simply handle it like a dropdown
      // unless it is a onLongPress, which can be found below
      if (hasChildren) {
        if (element.level + 1 == currentMenuState.length) {
          _currentlyOpenedElement = element;
          _renderChildrenOfElement(element);
        } else {
          _collapseAllOtherColumns(element);
          if (element != _currentlyOpenedElement) {
            _renderChildrenOfElement(element);
          }
        }
      }

      // if it has no children, this means it is an "item" we will simply toggle selection
      if (!hasChildren) {
        if (isActive) {
          MenuElement? parentElement = activeMenuChildren.firstWhereOrNull(
              (childElem) =>
                  getChildrenOfMenuElement(childElem).contains(element));
          if (parentElement != null) {
            _removeActiveElement(parentElement);
          }
          _removeActiveElement(element);
        } else {
          _addActiveElement(element);
        }
      }
    }

    onLongPressAction() {
      // Here we recursively need to DE-SELECT every child of the element
      if (isActive && element.childrenRef!.isNotEmpty) {
        // NOTE: somehow figure out the parent, and de-activate it as well if it is active
        MenuElement? parentElement = activeMenuChildren.firstWhereOrNull(
            (childElem) =>
                getChildrenOfMenuElement(childElem).contains(element));
        if (parentElement != null) {
          _removeActiveElement(parentElement);
        }
        _recursivelyDeactivateEveryChildOfElement(element);
        return;
      }

      if (element.childrenRef!.isNotEmpty) {
        // Add the element itself, and then add the children
        _recursivelyActivateEveryChildOfElement(element);

        // This is done to bring the currently being selected element back into focus
        // eg, if user is currenlty viewing "Cars" but decides to long select "Trucks"
        // we will select trucks and bring it back into focus
        _collapseAllOtherColumns(element);
        _renderChildrenOfElement(element);
      }
    }

      return widget.menuItemWidgetBuilder(
        element.key,
        onTapAction,
        onLongPressAction,
        isActive,
        !hasChildren,
        activeMenuChildren.any((activeElem) => children.contains(activeElem))
      );
  }

  List<Widget> _buildMenuState() {
    List<Widget> menuRepr = [];

    for (var i = 0; i < currentMenuState.length; i++) {
      final level = i;

      menuRepr.add(Expanded(
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
