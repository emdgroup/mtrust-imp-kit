/// Exception thrown to indicate errors related to the IMP reader.
///
/// This exception extends the [Error] class and is designed
/// to be used specifically for handling errors in the context of p-Chip reading.
class ImpReaderException extends Error {
  /// A message providing additional details about the IMP reader error.
  ///
  /// If not specified during the exception creation, a default message
  /// ("Unspecified IMP reader error") will be used.
  final String? message;

  /// Creates a new instance of [ImpReaderException].
  ///
  /// The [message] parameter can be used to provide additional details
  /// about the nature of the IMP reader error. If not specified,
  /// a default message will be used.
  ImpReaderException({this.message = "Unspecified IMP reader error"});
}
