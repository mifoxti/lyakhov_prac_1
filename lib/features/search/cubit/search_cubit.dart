import 'package:flutter_bloc/flutter_bloc.dart';

class SearchState {
  final int resultsCount;
  final String query;
  final List<String> searchHistory;
  final List<String> favoriteCategories;

  const SearchState({
    this.resultsCount = 25,
    this.query = '',
    this.searchHistory = const [],
    this.favoriteCategories = const ['Поп', 'Рок', 'Хип-хоп', 'Электроника', 'Джаз', 'Классика'],
  });

  SearchState copyWith({
    int? resultsCount,
    String? query,
    List<String>? searchHistory,
    List<String>? favoriteCategories,
  }) {
    return SearchState(
      resultsCount: resultsCount ?? this.resultsCount,
      query: query ?? this.query,
      searchHistory: searchHistory ?? this.searchHistory,
      favoriteCategories: favoriteCategories ?? this.favoriteCategories,
    );
  }
}

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(const SearchState());

  void increaseResults() {
    if (state.resultsCount < 100) {
      emit(state.copyWith(resultsCount: state.resultsCount + 5));
    }
  }

  void decreaseResults() {
    if (state.resultsCount > 5) {
      emit(state.copyWith(resultsCount: state.resultsCount - 5));
    }
  }

  void updateQuery(String newQuery) {
    emit(state.copyWith(query: newQuery));

    if (newQuery.isNotEmpty && !state.searchHistory.contains(newQuery)) {
      final updatedHistory = List<String>.from(state.searchHistory)..insert(0, newQuery);
      if (updatedHistory.length > 10) {
        updatedHistory.removeLast();
      }
      emit(state.copyWith(searchHistory: updatedHistory));
    }
  }

  void addFavoriteCategory(String category) {
    if (!state.favoriteCategories.contains(category)) {
      final updatedCategories = List<String>.from(state.favoriteCategories)..add(category);
      emit(state.copyWith(favoriteCategories: updatedCategories));
    }
  }

  void removeFavoriteCategory(String category) {
    if (state.favoriteCategories.contains(category)) {
      final updatedCategories = List<String>.from(state.favoriteCategories)..remove(category);
      emit(state.copyWith(favoriteCategories: updatedCategories));
    }
  }

  void clearSearchHistory() {
    emit(state.copyWith(searchHistory: []));
  }

  void setCustomResultsCount(int count) {
    if (count >= 0 && count <= 200) {
      emit(state.copyWith(resultsCount: count));
    }
  }
}