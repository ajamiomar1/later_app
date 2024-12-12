


import 'package:freezed_annotation/freezed_annotation.dart';


part 'HomeViewState.freezed.dart';

@freezed
class HomeViewState with _$HomeViewState {
  const factory HomeViewState({
    required List<Map<String,dynamic>> sharedContent,
}) = _HomeViewState;
}