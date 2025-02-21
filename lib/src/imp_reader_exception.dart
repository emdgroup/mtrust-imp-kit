/// Enumerates the types of exceptions that can be thrown by the IMP reader.
enum ImpReaderExceptionType {
  /// Firmware version installed on the device is incompatible
  incompatibleFirmware,
  /// Measurement failed
  measurementFailed,
  /// Failed to get or install new token
  tokenFailed,
  /// Unspecified error
  unspecified,
}

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
  /// The type of exception that was thrown. 
  /// The default value is [ImpReaderExceptionType.unspecified].
  final ImpReaderExceptionType? type;

  /// Creates a new instance of [ImpReaderException].
  ///
  /// The [message] parameter can be used to provide additional details
  /// about the nature of the IMP reader error. If not specified,
  /// a default message will be used.
  /// The [type] parameter can be used to specify the type of exception.
  ImpReaderException({
    this.message = "Unspecified IMP reader error", 
    this.type = ImpReaderExceptionType.unspecified,
  });
}
