import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:urid_api_client/urid_api_client.dart';

class SSLInformationDialog extends AlertDialog {
  final URIDPass pass;
  final BuildContext context;

  static TableRow _createDataRow(label, value, context) {
    String text = value is String ? value : DateFormat.yMMMd().format(value);
    return TableRow(children: <Widget>[
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Padding(
          padding: const EdgeInsets.all(2.5),
          child: Text(
            label,
            style: DefaultTextStyle.of(context).style.copyWith(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Padding(
          padding: const EdgeInsets.all(2.5),
          child: Text(
            text,
            style: DefaultTextStyle.of(context).style.copyWith(fontSize: 12, fontWeight: FontWeight.normal),
          ),
        ),
      )
    ]);
  }

  SSLInformationDialog(this.pass, this.context, {super.key})
      : super(
          title: ListTile(
            title: Text("Verbindungsinformationen"),
            subtitle: Text("Informationen zum SSL-Zertifikat des Wallet-Servers"),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Dieser Ausweis wurde über eine sichere Verbindung vom Wallet-Server der Universität Regensburg abgerufen. Die Integrität des Servers wurde vor dem Übertragen der Nutzerdaten und dem Abruf der Ausweise sichergestellt. Die folgenden Informationen wurden direkt aus dem SSL-Zertifikat des Servers ausgelesen"),
              const SizedBox(
                height: 8,
              ),
              Table(
                columnWidths: const <int, TableColumnWidth>{
                  0: FlexColumnWidth(3),
                  1: FlexColumnWidth(7),
                },
                children: <TableRow>[
                  _createDataRow(
                      "URL", pass.sslInformation!.url, context),
                  _createDataRow("Verifiziert von",
                      pass.sslInformation!.issuer, context),
                  _createDataRow("Inhaber",
                      pass.sslInformation!.holder, context),
                  _createDataRow("Gültig bis",
                      pass.sslInformation!.validUntil.toLocal(), context),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text("Schließen"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
}
