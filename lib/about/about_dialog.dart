import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yomikun/gen/assets.gen.dart';

final String developerEmail =
    String.fromCharCodes(base64.decode('cmljaGFyZGpoYXJyaXMreWtAZ21haWwuY29t'));

const String creativeCommonsLink =
    'https://creativecommons.org/licenses/by-sa/2.0';
const String splashLogoSource =
    'https://commons.wikimedia.org/wiki/File:Miyajima_Island_(44617818220).jpg';

/// Pops up an about dialog with app credits.
Future<void> showYomikunAboutDialog(context) async {
  final style = Theme.of(context).textTheme.bodyText2;

  TextSpan credits = TextSpan(
      style: style,
      text:
          'This app was created by Richard Harris ($developerEmail). Please contact me if you have any issues or feature requests. ');
  TextSpan credits2 = TextSpan(
      style: style,
      text:
          'Miyajima Island photo credited to Flickr user Dumphasizer, used under the CC BY-SA 2.0 license.');

  credits = linkify(context, credits, developerEmail, 'mailto:$developerEmail');
  credits2 =
      linkify(context, credits2, 'Miyajima Island photo', splashLogoSource);
  credits2 = linkify(context, credits2, 'CC BY-SA 2.0', creativeCommonsLink);

  showAboutDialog(
    context: context,
    applicationIcon: const Image(
        image: Assets.appicon,
        width: 40,
        height: 40,
        filterQuality: FilterQuality.medium),
    applicationVersion: 'beta',
    applicationLegalese: '\u{a9} 2022 Yomikun Developers',
    children: [
      const SizedBox(height: 20),
      RichText(text: credits),
      const SizedBox(height: 10),
      RichText(text: credits2),
    ],
  );
}

/// Replace [linkText] with a clickable link to [url].
///
/// [span] must have a style.
///
/// If [linkText] appears more than once in the span, only the first occurrence
/// will be turned into a link.
TextSpan linkify(
    BuildContext context, TextSpan span, String linkText, String url) {
  TextSpan returnValue;
  if (span.text != null && span.text!.contains(linkText)) {
    returnValue = TextSpan(
      style: span.style,
      children: [
        TextSpan(
          text: span.text!.substring(0, span.text!.indexOf(linkText)),
          style: span.style,
        ),
        TextSpan(
          text: linkText,
          style: span.style!.copyWith(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              launch(url);
            },
        ),
        TextSpan(
          text: span.text!.substring(
              span.text!.indexOf(linkText) + linkText.length,
              span.text!.length),
          style: span.style,
        ),
      ],
    );
  } else if (span.children != null) {
    /// Try searching the children
    returnValue = TextSpan(
      style: span.style,
      text: span.text,
      children: span.children!.map((child) {
        if (child is TextSpan) {
          return linkify(context, child, linkText, url);
        } else {
          return child;
        }
      }).toList(),
    );
  } else {
    returnValue = span;
  }

  return returnValue;
}
