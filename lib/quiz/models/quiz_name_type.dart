import 'package:flutter/widgets.dart';
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
  NamePart? toNamePart() {
    switch (this) {
      case QuizNameType.sei:
        return NamePart.sei;
      case QuizNameType.mei:
        return NamePart.mei;
      case QuizNameType.both:
        return null;
    }
  }

  String description(BuildContext context) {
    switch (this) {
      case QuizNameType.sei:
        return 'Given names';
      case QuizNameType.mei:
        return 'Family names';
      case QuizNameType.both:
        return 'All names';
    }
  }
}
