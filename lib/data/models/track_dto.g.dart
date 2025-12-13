// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackDto _$TrackDtoFromJson(Map<String, dynamic> json) => TrackDto(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String,
      artist: json['artist'] as String,
      duration: json['duration'] as String,
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$TrackDtoToJson(TrackDto instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'artist': instance.artist,
      'duration': instance.duration,
      'imageUrl': instance.imageUrl,
    };
