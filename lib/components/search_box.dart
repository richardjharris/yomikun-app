import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yomikun/models/query_mode.dart';

class SearchBoxInner extends HookWidget {
  final QueryMode queryMode;
  final Function(QueryMode?) onQueryModeChanged;
  final Function(String?) onSearchTextChanged;

  const SearchBoxInner(
      {Key? key,
      required this.onSearchTextChanged,
      required this.queryMode,
      required this.onQueryModeChanged})
      : super(key: key);

  String _queryModeToIcon(QueryMode mode) {
    switch (mode) {
      case QueryMode.mei:
        return '名';
      case QueryMode.sei:
        return '姓';
      case QueryMode.browse:
        return '＊';
      case QueryMode.person:
        return '人';
    }
  }

  QueryMode _nextQueryMode(QueryMode curMode) {
    // get next queryMode according to the Enum definition
    // we could define our own order if we liked.
    return QueryMode.values[(curMode.index + 1) % QueryMode.values.length];
  }

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    useEffect(() {
      void listener() => onSearchTextChanged(controller.text);
      controller.addListener(listener);
      return () => controller.removeListener(listener);
    }, [controller]);

    return Row(children: [
      Expanded(
          child: TextField(
        controller: controller,
        autofocus: true,
        textInputAction: TextInputAction.search,
        autocorrect: false,
        textCapitalization: TextCapitalization.none,
        decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).primaryColorLight,
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () => controller.clear(),
          ),
        ),
      )),
      const SizedBox(width: 10),
      IconButton(
        icon: Text(_queryModeToIcon(queryMode)),
        onPressed: advanceMode,
        iconSize: 30,
      ),
    ]);
  }

  void advanceMode() {
    // advance to next mode
    onQueryModeChanged(_nextQueryMode(queryMode));
  }
}
