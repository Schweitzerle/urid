import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:urid_api_client/urid_api_client.dart';
import '../../../models/strings.dart';

abstract class BasePassWidgetProperties extends StatefulWidget {
  final URIDPass pass;
  final bool showHiddenProperties;

  const BasePassWidgetProperties({required this.pass, required this.showHiddenProperties, super.key});
}

abstract class BasePassWidgetPropertiesState<T extends BasePassWidgetProperties> extends State<T> {
  TableRow createPropertyContainer(PassProperty property) {
    String text = property.value;
    try {
      DateFormat formatter = DateFormat.yMMMMd();
      text = formatter.format(DateTime.parse(text));
    } catch (error) {}
    return TableRow(children: <Widget>[
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Padding(
          padding: const EdgeInsets.all(2.5),
          child: Text(
            property.label.get()!,
            style: DefaultTextStyle.of(context).style.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 14,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Padding(
          padding: const EdgeInsets.all(2.5),
          child: Text(
            text,
            style: DefaultTextStyle.of(context).style.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 14,
                fontWeight: FontWeight.normal),
          ),
        ),
      )
    ]);
  }

  List<TableRow> getProperties() {
    List<TableRow> properties = List.empty(growable: true);
    for (var property in widget.pass.properties.values) {
      if (property.type == "text") {
        properties.add(createPropertyContainer(property));
      }
    }
    return properties;
  }

  Widget buildPropertiesTable() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Table(
        border: TableBorder(
            horizontalInside: BorderSide(
                width: 1,
                color: Theme.of(context).colorScheme.onPrimary,
                style: BorderStyle.solid)),
        columnWidths: const <int, TableColumnWidth>{
          0: FlexColumnWidth(4),
          1: FlexColumnWidth(6),
        },
        children: getProperties(),
      ),
    );
  }

  @override
  Widget build(BuildContext context);
}

class PassWidgetPropertiesButton extends BasePassWidgetProperties {
  const PassWidgetPropertiesButton({required URIDPass pass, required bool showHiddenProperties, super.key})
      : super(pass: pass, showHiddenProperties: showHiddenProperties);

  @override
  State<PassWidgetPropertiesButton> createState() => _PassWidgetPropertiesButtonState();
}

class _PassWidgetPropertiesButtonState extends BasePassWidgetPropertiesState<PassWidgetPropertiesButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          child: RotationTransition(
            turns: !widget.showHiddenProperties
                ? AlwaysStoppedAnimation(180 / 360)
                : AlwaysStoppedAnimation(0 / 360),
            child: ListTile(
            title: Text(!widget.showHiddenProperties ? Strings.publicView : Strings.privateView,
                style: DefaultTextStyle.of(context).style.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            subtitle: Text(!widget.showHiddenProperties ? Strings.releaseToShow : Strings.holdToHide,
                style: DefaultTextStyle.of(context).style.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 14)),
            leading: Icon(!widget.showHiddenProperties ? Icons.visibility : Icons.visibility_off,
                color: Theme.of(context).colorScheme.onPrimary),
          ),
        ),
        ),
        if (widget.showHiddenProperties == true)
          buildPropertiesTable(),
      ],
    );
  }
}

class PassWidgetPropertiesCover extends BasePassWidgetProperties {
  const PassWidgetPropertiesCover({required URIDPass pass, super.key})
      : super(pass: pass, showHiddenProperties: true);

  @override
  State<PassWidgetPropertiesCover> createState() => _PassWidgetPropertiesCoverState();
}

class _PassWidgetPropertiesCoverState extends BasePassWidgetPropertiesState<PassWidgetPropertiesCover> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildPropertiesTable(),
      ],
    );
  }
}

class PassWidgetPropertiesVolumeButton extends BasePassWidgetProperties {
  const PassWidgetPropertiesVolumeButton({required URIDPass pass, required bool showHiddenProperties, super.key})
      : super(pass: pass, showHiddenProperties: showHiddenProperties);

  @override
  State<PassWidgetPropertiesVolumeButton> createState() => _PassWidgetPropertiesVolumeButtonState();
}

class _PassWidgetPropertiesVolumeButtonState extends BasePassWidgetPropertiesState<PassWidgetPropertiesVolumeButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          child:  RotationTransition(
            turns: !widget.showHiddenProperties
                ? AlwaysStoppedAnimation(180 / 360)
                : AlwaysStoppedAnimation(0 / 360),
            child: ListTile(
            title: Text(!widget.showHiddenProperties ? Strings.publicView : Strings.privateView,
                style: DefaultTextStyle.of(context).style.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            subtitle: Text(!widget.showHiddenProperties ? Strings.volumeHoldToShow : Strings.volumeHoldToHide,
                style: DefaultTextStyle.of(context).style.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 14)),
            leading: Icon(widget.showHiddenProperties ? Icons.visibility : Icons.visibility_off,
                color: Theme.of(context).colorScheme.onPrimary),
          ),
        ),
        ),
        if (widget.showHiddenProperties == true)
          buildPropertiesTable(),
      ],
    );
  }
}

class PassWidgetPropertiesFlip extends BasePassWidgetProperties {
  const PassWidgetPropertiesFlip({required URIDPass pass, required bool showHiddenProperties, super.key})
      : super(pass: pass, showHiddenProperties: showHiddenProperties);

  @override
  State<PassWidgetPropertiesFlip> createState() => _PassWidgetPropertiesFlipState();
}

class _PassWidgetPropertiesFlipState extends BasePassWidgetPropertiesState<PassWidgetPropertiesFlip> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RotationTransition(
            turns: !widget.showHiddenProperties
                ? AlwaysStoppedAnimation(180 / 360)
                : AlwaysStoppedAnimation(0 / 360),
            child: ListTile(
          title: Text(
              !widget.showHiddenProperties
                  ? Strings.publicView
                  : Strings.privateView,
              style: DefaultTextStyle.of(context).style.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          subtitle: Text(
              widget.showHiddenProperties
                  ? Strings.tiltForwardToHide
                  : Strings.tiltBackwardToShow,
              style: DefaultTextStyle.of(context).style.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 14)),
          leading: Icon(
              widget.showHiddenProperties
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: Theme.of(context).colorScheme.onPrimary),
        ),
        ),
        if (widget.showHiddenProperties == true)
          buildPropertiesTable(),
      ],
    );
  }
}
