import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../common/enums.dart';

final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

class Media extends ChangeNotifier {
  final int id;
  final MediaType mediaType;
  final bool? adult;
  final String title;

  Media({
    required this.id,
    required this.mediaType,
    this.adult = false,
    required this.title,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'media_type': mediaType,
        'adult': adult,
        'title': title,
      };

  factory Media.fromJson(Map<String, dynamic> jsonMap) {
    // print('factory Media.fromJson(id: ${jsonMap['id']} - title: ${jsonMap['title']})');
    // print('factory Media.fromJson(jsonMap: $jsonMap');

    String mediaTypeStr  = jsonMap['media_type'] ?? 'movie';
    MediaType tMediaType = mediaTypeStr == 'movie' ? MediaType.movie : mediaTypeStr == 'person' ? MediaType.person : MediaType.tv;

    // print('RETURN - factory Media.fromJson');
    return Media(
      id: jsonMap['id'],
      mediaType: tMediaType,
      adult: jsonMap['adult'],
      title: jsonMap['title'] ?? jsonMap['name'],
    );
  }

  @override
  String toString() {
    return 'id: $id, title: $title';
  }

  @override
  int get hashCode {
    return id.hashCode;
  }

  @override
  bool operator ==(Object other) {
    return other is Media && other.id == id && other.title == title;
  }
}
