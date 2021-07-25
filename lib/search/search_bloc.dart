import "package:bloc/bloc.dart";

class SearchState {
  SearchState({this.items});

  final List<SearchItem>? items;

  SearchState copyWith({List<SearchItem>? items}) =>
      SearchState(items: items ?? this.items);
}

abstract class SearchEvent {}

class OnItemClickEvent extends SearchEvent {
  OnItemClickEvent(this.item);

  final SearchItem item;
}

class OnPullToRefreshEvent extends SearchEvent {}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchState());

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is OnItemClickEvent) {
    } else if (event is OnPullToRefreshEvent) {}
  }
}

class SearchItem {
  final String name = "";
}
