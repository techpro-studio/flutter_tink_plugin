import 'package:json_annotation/json_annotation.dart';
part 'tink_result.g.dart';

class _StateValues {
  static const success = "success";
  static const error = "error";
  static const userCancelled = "user_cancelled";
}

enum State {
@JsonValue(_StateValues.success)
Success,
@JsonValue(_StateValues.error)
Error,
@JsonValue(_StateValues.userCancelled)
UserCancelled
}

@JsonSerializable()
class TinkResult {
  final State state;
  final Map<String, String> data;

  TinkResult(this.state, this.data);

  Map<String, dynamic> toJson() => _$TinkResultToJson(this);

  factory TinkResult.fromJson(Map<String, dynamic> json) => _$TinkResultFromJson(json);

}
