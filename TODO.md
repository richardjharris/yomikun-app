Bookmarks:
 - bookmark entire page or individual item (?)
 - add/remove

History:
 - record history using debounce in results page
 - clear history
 - group by time range a la Pleco

NameBreakdown:
 - gender split
 - fictional count

Explore:
 - most popular names
 - most popular kanji
 - unisex names
 - kanji allowed in names
 - kanji associated with either gender


## Name listing

Show some kind of proportional bar to show usage.

## Person view

Switch automatically.

Show small '?' if there are many suitable readings.

Handle kana/romaji.

## Redoing the search logic

Search logic should go into a SearchController that gets passed around.
 - Maintains query mode, search text, caches results
 - clearQuery(), setQuery(), nextMode()
 - emits a stream of Query and QueryResult

getAllowedQueryModes does a prefix match (not an exact match), which
can actually lead to no results.

When input does not match, should revert to last user-selected mode
(like Pleco) e.g. on backspace. Should preserve mode across 'no results'
and then I can stop doing a prefix match.

Not sure about QueryMode.person atm.

QueryModeButton highlight if no results - should preserve previous value
when loading. May already be done in riverpod 2.

We should not switch to querymode.person if there are no person results
 - should stay on the last query mode.

任天堂 seems to be parsed as a name, but no given name results.