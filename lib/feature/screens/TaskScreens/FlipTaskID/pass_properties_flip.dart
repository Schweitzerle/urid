import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:urid_api_client/urid_api_client.dart';

class PassWidgetPropertiesFlip extends StatefulWidget {
  final URIDPass pass;
  bool showHiddenProperties;

  PassWidgetPropertiesFlip({required this.pass, required this.showHiddenProperties, super.key});

  @override
  State<PassWidgetPropertiesFlip> createState() => _PassWidgetPropertiesFlip();
}

class _PassWidgetPropertiesFlip extends State<PassWidgetPropertiesFlip> {

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


  //TODO: Vllt noch widget drehen implementieren, muss man die usablility noch untersuchen
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
        ListTile(
          title: Text(widget.showHiddenProperties ? 'Öffentliche Ansicht' : 'Private Ansicht',
              style: DefaultTextStyle.of(context).style.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          subtitle: Text(widget.showHiddenProperties ? 'Smartphone nach vorne neigen, um Inhalte auszublenden' : 'Smartphone nach hinten neigen, um Inhalte anzuzeigen',
              style: DefaultTextStyle.of(context).style.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 14)),
          leading: Icon(widget.showHiddenProperties ? Icons.visibility : Icons.visibility_off,
              color: Theme.of(context).colorScheme.onPrimary),
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
