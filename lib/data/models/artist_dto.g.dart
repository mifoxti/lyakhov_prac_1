// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArtistDto _$ArtistDtoFromJson(Map<String, dynamic> json) => ArtistDto(
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String?,
      genre: json['genre'] as String?,
      listeners: (json['listeners'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ArtistDtoToJson(ArtistDto instance) => <String, dynamic>{
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'genre': instance.genre,
      'listeners': instance.listeners,
    };
