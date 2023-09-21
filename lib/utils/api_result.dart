sealed class ApiResult<T> {
  abstract String? message;
  abstract T? data;

  ApiResult() : super();

  factory ApiResult.success(T data, {String? message}) =>
      ApiResultSuccess(data);

  factory ApiResult.failure(String message, {T? data}) =>
      ApiResultFailure(message);
}

class ApiResultSuccess<T> extends ApiResult<T> {
  @override
  String? message;

  @override
  T? data;

  ApiResultSuccess(this.data);
}

class ApiResultFailure<T> extends ApiResult<T> {
  @override
  String? message;

  @override
  T? data;

  ApiResultFailure(this.message);
}

class ApiResultLoading<T> extends ApiResult<T> {
  @override
  String? message;

  @override
  T? data;

  ApiResultLoading();
}
