import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:urid_api_client/urid_api_client.dart';

class PassWidgetPropertiesFingerprint extends StatefulWidget {
  final URIDPass pass;
  final bool showHiddenProperties;
  void Function() onAuthenticate;

  PassWidgetPropertiesFingerprint({
    required this.pass,
    required this.showHiddenProperties,
    required this.onAuthenticate,
    Key? key,
  }) : super(key: key);

  @override
  State<PassWidgetPropertiesFingerprint> createState() => _PassWidgetPropertiesFingerprintState();
}

class _PassWidgetPropertiesFingerprintState extends State<PassWidgetPropertiesFingerprint> {
  TableRow _createPropertyContainer(PassProperty property) {
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

  @override
  Widget build(BuildContext context) {
    List<TableRow> properties = List.empty(growable: true);
    for (var property in widget.pass.properties.values) {
      if (property.type == "text") {
        properties.add(_createPropertyContainer(property));
      }
    }
    return Column(
      children: [
        GestureDetector(
          onTap: widget.onAuthenticate,
          child: ListTile(
            title: Text(
                widget.showHiddenProperties
                    ? 'Öffentliche Ansicht'
                    : 'Private Ansicht',
                style: DefaultTextStyle.of(context).style.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            subtitle: Text(
                widget.showHiddenProperties
                    ? 'Drücken um Inhalte durch Fingerabdruck auszublenden'
                    : 'Drücken um Inhalte durch Fingerabdruck anzuzeigen',
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
        if (widget.showHiddenProperties)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Table(
              border: TableBorder(
                  horizontalInside: BorderSide(
                      width: 1,
                      color: Theme.of(context).colorScheme.onPrimary,
                      style: BorderStyle.solid)),
              columnWidths: const <int, TableColumnWidth>{
                0: FixedColumnWidth(150),
                1: FlexColumnWidth()
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: properties,
            ),
          )
      ],
    );
  }
}
