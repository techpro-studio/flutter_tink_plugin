// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tink_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TinkResult _$TinkResultFromJson(Map<String, dynamic> json) {
  return TinkResult(
    _$enumDecodeNullable(_$StateEnumMap, json['state']),
    (json['data'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
  );
}

Map<String, dynamic> _$TinkResultToJson(TinkResult instance) =>
    <String, dynamic>{
      'state': _$StateEnumMap[instance.state],
      'data': instance.data,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$StateEnumMap = {
  State.Success: 'success',
  State.Error: 'error',
  State.UserCancelled: 'user_cancelled',
};
