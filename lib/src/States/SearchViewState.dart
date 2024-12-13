


import 'package:freezed_annotation/freezed_annotation.dart';


part 'SearchViewState.freezed.dart';

@freezed
class SearchViewState with _$SearchViewState {
  const factory SearchViewState({
    required List<Map<String,dynamic>> sharedContent,
  }) = _SearchViewState;
}