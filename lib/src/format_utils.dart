enum ChipIdFormat { dec, hex, mac }

String _uint32ToMacAddress(int number) {
  // Convert the uint32 to 4 bytes (32 bits / 8 bits per byte)
  List<int> bytes = [
    (number >> 24) & 0xFF,
    (number >> 16) & 0xFF,
    (number >> 8) & 0xFF,
    number & 0xFF,
  ];

  // Format bytes as a MAC address-like string
  String macAddress =
      bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(':');

  return macAddress;
}

/// Formats a chip ID according to the given format. The format can be one of:
/// - [ChipIdFormat.dec] for decimal format
/// - [ChipIdFormat.hex] for hexadecimal format
/// - [ChipIdFormat.mac] for a MAC address-like format, that is, a
/// colon-separated string of 8 hexadecimal digits
String formatChipId(int value, ChipIdFormat format) {
  return switch (format) {
    (ChipIdFormat.dec) => value.toString(),
    (ChipIdFormat.hex) => value.toRadixString(16).toUpperCase(),
    (ChipIdFormat.mac) => _uint32ToMacAddress(value).toUpperCase(),
  };
}
