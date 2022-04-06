import 'package:flutter/widgets.dart';
import 'package:yomikun/localization/app_localizations_context.dart';
import 'package:yomikun/search/models.dart';

/// Type of name to be used in quiz questions.
enum QuizNameType {
  sei,
  mei,
  both,
}

extension QuizNameTypeStringExt on String {
  QuizNameType toQuizNameType() {
    return QuizNameType.values.firstWhere((e) => e.name == this);
  }
}

extension QuizNameTypeMethods on QuizNameType {
  /// Returns a list of applicable [NamePart]s for this [QuizNameType].
  List<NamePart> toNameParts() {
    switch (this) {
      case QuizNameType.sei:
        return [NamePart.sei];
      case QuizNameType.mei:
        return [NamePart.mei];
      case QuizNameType.both:
        return [NamePart.sei, NamePart.mei];
    }
  }

  String description(BuildContext context) {
    switch (this) {
      case QuizNameType.sei:
        return context.loc.qzFamilyNames;
      case QuizNameType.mei:
        return context.loc.qzGivenNames;
      case QuizNameType.both:
        return context.loc.qzAllNames;
    }
  }
}
