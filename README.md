# yomikun/app

Flutter application for browsing the Yomikun Japanese names database
(Android/iOS/web/desktop)

# Design

There are a few types of query you can do:
 - convert kana to kanji
 - convert kanji to kana
 - perform wildcard searches (type a * or ?)
 - produce readings for full kanji names, with or without spaces

The mode selector to the right of the search box allows you to flip
through all applicable modes.

When showing a set of names (e.g. all names with the same reading,
or same kanji) a visualisation shows you the approximate distribution
of names, so you know if one is very common, or if there is a lot of
variety. This can be set to either a box chart or a pie chart, or
turned off.

Names can be displayed in romaji, kana, or kana with emphasized dakuten
and handakuten (゛and ゜). The application is fully localised in both
English and Japanese.

## Bookmarks, History

Name result pages can be bookmarked and appear in the history.
Individual names can also be bookmarked for reference, or shared
to Anki or your Flashcard program of choice.

## Explore

You can see stats on the most common names, kanji, info on unisex
names, and the relationship between kanji and gender in Japan.

## OCR (beta)

The debug build provides a rudimentary OCR page to capture names
from your phone's camera. Due to limitations in Google's OCR it
is not great at recognising names (it seems suited for full
sentences) so this needs some work done.