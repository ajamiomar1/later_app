// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'SearchViewState.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SearchViewState {
  List<Map<String, dynamic>> get sharedContent =>
      throw _privateConstructorUsedError;

  /// Create a copy of SearchViewState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchViewStateCopyWith<SearchViewState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchViewStateCopyWith<$Res> {
  factory $SearchViewStateCopyWith(
          SearchViewState value, $Res Function(SearchViewState) then) =
      _$SearchViewStateCopyWithImpl<$Res, SearchViewState>;
  @useResult
  $Res call({List<Map<String, dynamic>> sharedContent});
}

/// @nodoc
class _$SearchViewStateCopyWithImpl<$Res, $Val extends SearchViewState>
    implements $SearchViewStateCopyWith<$Res> {
  _$SearchViewStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchViewState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sharedContent = null,
  }) {
    return _then(_value.copyWith(
      sharedContent: null == sharedContent
          ? _value.sharedContent
          : sharedContent // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SearchViewStateImplCopyWith<$Res>
    implements $SearchViewStateCopyWith<$Res> {
  factory _$$SearchViewStateImplCopyWith(_$SearchViewStateImpl value,
          $Res Function(_$SearchViewStateImpl) then) =
      __$$SearchViewStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Map<String, dynamic>> sharedContent});
}

/// @nodoc
class __$$SearchViewStateImplCopyWithImpl<$Res>
    extends _$SearchViewStateCopyWithImpl<$Res, _$SearchViewStateImpl>
    implements _$$SearchViewStateImplCopyWith<$Res> {
  __$$SearchViewStateImplCopyWithImpl(
      _$SearchViewStateImpl _value, $Res Function(_$SearchViewStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of SearchViewState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sharedContent = null,
  }) {
    return _then(_$SearchViewStateImpl(
      sharedContent: null == sharedContent
          ? _value._sharedContent
          : sharedContent // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
    ));
  }
}

/// @nodoc

class _$SearchViewStateImpl implements _SearchViewState {
  const _$SearchViewStateImpl(
      {required final List<Map<String, dynamic>> sharedContent})
      : _sharedContent = sharedContent;

  final List<Map<String, dynamic>> _sharedContent;
  @override
  List<Map<String, dynamic>> get sharedContent {
    if (_sharedContent is EqualUnmodifiableListView) return _sharedContent;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sharedContent);
  }

  @override
  String toString() {
    return 'SearchViewState(sharedContent: $sharedContent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchViewStateImpl &&
            const DeepCollectionEquality()
                .equals(other._sharedContent, _sharedContent));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_sharedContent));

  /// Create a copy of SearchViewState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchViewStateImplCopyWith<_$SearchViewStateImpl> get copyWith =>
      __$$SearchViewStateImplCopyWithImpl<_$SearchViewStateImpl>(
          this, _$identity);
}

abstract class _SearchViewState implements SearchViewState {
  const factory _SearchViewState(
          {required final List<Map<String, dynamic>> sharedContent}) =
      _$SearchViewStateImpl;

  @override
  List<Map<String, dynamic>> get sharedContent;

  /// Create a copy of SearchViewState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchViewStateImplCopyWith<_$SearchViewStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
