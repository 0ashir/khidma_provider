import 'package:any_link_preview/any_link_preview.dart';

import 'package:edemand_partner/app/generalImports.dart';
import 'package:flutter/material.dart';

class LinkPreview extends StatelessWidget {
  final String link;
  final AsyncSnapshot snapshot;

  const LinkPreview({super.key, required this.snapshot, required this.link});

  @override
  Widget build(BuildContext context) {
    return (snapshot.data as Metadata).image == null &&
            (snapshot.data as Metadata).title == null &&
            (snapshot.data as Metadata).desc == null
        ? const SizedBox.shrink()
        : GestureDetector(
            onTap: () async {
              await launchUrl(
                Uri.parse(link),
                mode: LaunchMode.externalApplication,
              );
            },
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).colorScheme.secondaryColor,
              ),
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(bottom: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if ((snapshot.data as Metadata).image != null)
                    Container(
                      constraints: const BoxConstraints(maxHeight: 150),
                      padding: const EdgeInsets.symmetric(vertical: 2.5),
                      child: CachedNetworkImage(
                        memCacheHeight: 500,
                        memCacheWidth: 500,
                        imageUrl: (snapshot.data as Metadata).image!,
                        errorWidget: (context, url, error) =>
                            const SizedBox.shrink(),
                      ),
                    ),
                  if ((snapshot.data as Metadata).title != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.5),
                      child: Text(
                        (snapshot.data as Metadata).title ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  if ((snapshot.data as Metadata).desc != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.5),
                      child: Text(
                        (snapshot.data as Metadata).desc ?? '',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                ],
              ),
            ),
          );
  }
}

List replaceLink({required String text}) {
  //This function will make part of text where link starts. we put invisible character so we can split it with it
  final linkPattern = RegExp(
    r"(http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)",
  );

  ///This is invisible character [You can replace it with any special character which generally nobody use]
  const String substringIdentifier = "‎";

  ///This will find and add invisible character in prefix and suffix
  final String splitMapJoin = text.splitMapJoin(
    linkPattern,
    onMatch: (match) {
      return substringIdentifier + match.group(0)! + substringIdentifier;
    },
    onNonMatch: (match) {
      return match;
    },
  );
  //finally we split it with invisible character so it will become list
  return splitMapJoin.split(substringIdentifier);
}

bool isLink(String input) {
  ///This will check if text contains link
  final matcher = RegExp(
    r"(http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)",
  );
  return matcher.hasMatch(input);
}

List<String> matchAstric(String data) {
  final pattern = RegExp(r"\*(.*?)\*");

  final String mapJoin = data.splitMapJoin(
    pattern,
    onMatch: (p0) {
      return "‎${p0.group(0)!}‎";
    },
    onNonMatch: (p0) {
      return p0;
    },
  );

  return mapJoin.split("‎");
}
