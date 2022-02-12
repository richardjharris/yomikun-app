Implement 'Flutter Starter Project' stuff
 - per-feature directories

Settings page?
 - romaji vs katakana
 - highlight tenten
 - pie chart vs. treemap vs. none?
 - dark/light mode

Bookmarks:
 - bookmark entire page or individual item (?)
 - add/remove

Treemap:
 - dakuten, locale
 - accept ky + results or similar, to cache sorting and filtering. or use riverpod
   with overrides?

## Person view

Switch automatically.

Show small '?' if there are many suitable readings.

Make sure it uses the same localisation, romaji, dakuten etc.

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