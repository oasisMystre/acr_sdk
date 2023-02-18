class HttpError extends Error {
  final int httpStatus;
  final String? message;

  HttpError({
    required this.httpStatus,
    this.message,
  });
}
