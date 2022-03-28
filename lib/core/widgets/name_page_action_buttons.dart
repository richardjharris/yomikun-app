import 'package:flutter/material.dart';
import 'package:yomikun/localization/app_localizations_context.dart';

/// Action buttons that appear at the top of the some pages.
class NamePageActionButtons extends StatelessWidget {
  final bool isBookmarked;
  final VoidCallback onBookmark;
  final VoidCallback onShare;

  const NamePageActionButtons(
      {Key? key,
      required this.isBookmarked,
      required this.onBookmark,
      required this.onShare})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(isBookmarked ? Icons.star : Icons.star_border),
          onPressed: onBookmark,
          tooltip: isBookmarked
              ? context.loc.removeBookmarkTooltip
              : context.loc.addBookmarkTooltip,
        ),
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: onShare,
          tooltip: context.loc.shareTooltip,
        ),
      ],
    );
  }
}
