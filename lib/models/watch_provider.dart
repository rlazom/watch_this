import 'dart:io' show File;

class WatchProvider implements Comparable<WatchProvider> {
  final int providerId;
  final String providerName;
  final String? logoPath;
  final int displayPriority;
  final String? type;
  final String locale;
  Future<File?>? fLogo;

  WatchProvider({
    required this.providerId,
    required this.providerName,
    this.logoPath,
    this.type,
    required this.locale,
    required this.displayPriority,
  });

  factory WatchProvider.fromJson(Map<String, dynamic> jsonMap, {String? locale, String? type}) {
    return WatchProvider(
      providerId: jsonMap['provider_id'],
      providerName: jsonMap['provider_name'],
      logoPath: jsonMap['logo_path'],
      type: type ?? jsonMap['type'],
      locale: locale ?? jsonMap['locale'],
      displayPriority: jsonMap['display_priority'],
    );
  }

  @override
  String toString() {
    return providerName;
  }

  @override
  int get hashCode {
    return providerId.hashCode;
  }

  @override
  bool operator ==(Object other) {
    return other is WatchProvider &&
        other.providerId == providerId &&
        other.providerName == providerName;
  }

  @override
  int compareTo(WatchProvider other) {
    return (displayPriority).compareTo((other.displayPriority));
  }
}
