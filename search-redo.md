UI redo:
 - use tap for android. tap name, pops up a menu
   Heading: the name selected
   Choices: 
    - See other readings
    - Copy
    - Share
    - Bookmark

   Can maybe keep sliding for iOS.

   Grid should be clickable, and jump to the correct item.

---
Problems:
 1) tiny problem with wildcard: ん* matches no, na etc.

 2) Search picks the wrong mode (sei/mei)
   - specifically, if there are only 0-hit results, we should switch.

 3) sometimes typing stuff just doesn't do anything. input box being rebuilt?
    loss of focus? 

 4) no results appears in Person mode. minor, but could show something else.

## Current search logic

User text: textEditingController (searchTextProvider)
query mode: queryModeProvider

allowedQueryModeProvider: reacts to search text change, updates

queryProvider: listens to searchText and queryMode; updates queryMode if not allowed

queryResultProvider: makes queries when query updates.

## Notes on redoing the search logic

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