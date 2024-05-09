import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:urid_api_client/urid_api_client.dart';

class PassWidgetHeader extends StatelessWidget {
  final URIDPass pass;

  const PassWidgetHeader({required this.pass, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: CachedNetworkImage(
          height: 50,
          width: 50,
          imageUrl: pass.providerLogo,
          placeholder: (BuildContext context, url) => CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            radius: 150,
          ),
          imageBuilder: (BuildContext context, image) => Container(
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              image: DecorationImage(image: image, fit: BoxFit.contain),
            ),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        title: Text(pass.title.get()!,
            style: DefaultTextStyle.of(context)
                .style
                .copyWith(color: Theme.of(context).colorScheme.onPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
        subtitle: Text(pass.providerDepartment.get()!,
            style: DefaultTextStyle.of(context)
                .style
                .copyWith(color: Theme.of(context).colorScheme.onPrimary, fontSize: 16, fontWeight: FontWeight.bold)));
  }
}
