import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:urid_api_client/urid_api_client.dart';

class PassWidgetPropertiesCover extends StatefulWidget {
  final URIDPass pass;

  const PassWidgetPropertiesCover({required this.pass, super.key});

  @override
  State<PassWidgetPropertiesCover> createState() => _PassWidgetPropertiesCover();
}

class _PassWidgetPropertiesCover extends State<PassWidgetPropertiesCover> {
  bool showHiddenProperties = true;

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
            style: DefaultTextStyle.of(context)
                .style
                .copyWith(color: Theme.of(context).colorScheme.onPrimary, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Padding(
          padding: const EdgeInsets.all(2.5),
          child: Text(
            text,
            style: DefaultTextStyle.of(context)
                .style
                .copyWith(color: Theme.of(context).colorScheme.onPrimary, fontSize: 14, fontWeight: FontWeight.normal),
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Table(
            border: TableBorder(
                horizontalInside:
                    BorderSide(width: 1, color: Theme.of(context).colorScheme.onPrimary, style: BorderStyle.solid)),
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
