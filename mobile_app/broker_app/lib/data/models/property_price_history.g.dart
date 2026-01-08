// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_price_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PropertyPriceHistory _$PropertyPriceHistoryFromJson(
        Map<String, dynamic> json) =>
    PropertyPriceHistory(
      id: (json['id'] as num?)?.toInt(),
      oldPrice: _doubleFromJson(json['old_price']),
      newPrice: _doubleFromJson(json['new_price']),
      changedAt: json['changed_at'] == null
          ? null
          : DateTime.parse(json['changed_at'] as String),
    );

Map<String, dynamic> _$PropertyPriceHistoryToJson(
        PropertyPriceHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'old_price': instance.oldPrice,
      'new_price': instance.newPrice,
      'changed_at': instance.changedAt?.toIso8601String(),
    };
