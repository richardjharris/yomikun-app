Bookmarks:
 - bookmark individual items -> jump to item
 - add/remove

History:
 - record history using debounce in results page
 - clear history
 - group by time range a la Pleco

## Hive

Consider using JSON for storage - it is just nicer, and freezed can provide
fromJson.

## Kanji for names - gender

Has to be baked into the database via the backend process.

## Navigation

Clicking 'search' doesn't seem to work all the time from drawer.

Either fix the NavigationDrawer to work correctly or consider an IndexedStack approach
(but that doesn't do history or transitions). Or consider flutter_nav or GoRouter (which
everyone seems to use).

productive_cats: uses Drawer with a selected element, which sets ListTile.selected
defines
  void Function() navigateRoute(BuildContext context, String route) {
    return () {
      Navigator.pop(context); // close drawer
      context.push(route);
    };
  }
  -> onTap: navigateRoute(context, '/cats'),

Note that you can do  Navigator.popUntil(context, ModalRoute.withName("/screen2"));
and   Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Screen2(),
                settings: RouteSettings(name: '/screen2')),
          );

 - makoto route doesn't quite work right, ends up with Search button being a no-op
   investigate why
 - animations should be slide from right, or fade. But CupertinoPageRoute causes
   the Drawer to slide right in some cases, and look weird.

 - pushing on the same route creates an animation, we shouldn't do that.
   - seems like it's pushing multiple of the same route.
   - it is!
 - down animation is wrong.

 - maybe use AboutListTile

 - Could consider using a Stack to simplify navigation
   https://stackoverflow.com/questions/67490813/flutter-drawer-show-existing-page-if-exists-not-a-new-instance

### Other approaches

Pleco: hamburger on main page. Drawe size is ~50% of screen. 
  Instant access to dark/light mode and simplified/traditional chars
  Hamburger on all pages
  Subpages use back button.
  Viewing history items: has back button. Uses scroll transition.
  Viewing any kind of search result pushes a 'back button' view.

Aedict: hamburger on main page. Drawer is quite big, but header remains in view
  and changes hamburger to back button. Sort of broken though.
  Navigation is confusing as each query pops on a new route with the same hamburger menu,
    when you'd expect the route to be replaced.

## CC Credit


## Bookmarks

Use slideable, for consistency with the rest of the code,
and also prevents accidental un-bookmarking.

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