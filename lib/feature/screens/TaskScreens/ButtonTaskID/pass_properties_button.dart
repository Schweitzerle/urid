import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:urid_api_client/urid_api_client.dart';

class PassWidgetPropertiesButton extends StatefulWidget {
  final URIDPass pass;
  bool showHiddenProperties;

  PassWidgetPropertiesButton({required this.pass, required this.showHiddenProperties, super.key});

  @override
  State<PassWidgetPropertiesButton> createState() => _PassWidgetProperties();
}

class _PassWidgetProperties extends State<PassWidgetPropertiesButton> {

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
          child: ListTile(
            title: Text(widget.showHiddenProperties ? 'Öffentliche Ansicht' : 'Private Ansicht',
                style: DefaultTextStyle.of(context).style.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            subtitle: Text(widget.showHiddenProperties ? 'Loslassen, um Inhalte auszublenden' : 'Pass irgendwo Gedrückt halten, um Inhalte anzuzeigen',
                style: DefaultTextStyle.of(context).style.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 14)),
            leading: Icon(widget.showHiddenProperties ? Icons.visibility : Icons.visibility_off,
                color: Theme.of(context).colorScheme.onPrimary),
          ),
        ),
    if (widget.showHiddenProperties == true)
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Table(
          border: TableBorder(
              horizontalInside: BorderSide(
                  width: 1,
                  color: Theme
                      .of(context)
                      .colorScheme
                      .onPrimary,
                  style: BorderStyle.solid)),
          columnWidths: const <int, TableColumnWidth>{
            0: FlexColumnWidth(4),
            1: FlexColumnWidth(6),
          },
          children: properties,
        ),
      ),
      ],
    );
  }
}
