import 'package:meta/meta.dart';

@immutable
class PrinterEntity {
  PrinterEntity({
    this.id: '',
    this.name: '',
    this.status: '',
    this.description: '',
    this.image: '',
    this.distance: 0,
  });

  factory PrinterEntity.fromJson(Map<String, dynamic> data) {


    return new PrinterEntity(
      id: data['id'] as String,
      name: data['name'] as String,
      status: data['status'] as String,
      description: data['description'] as String,
      image: data['image'] as String,
      distance: data['distance'] as int,
    );
  }

  final String id;
  final String name;
  final String status;
  final String description;
  final String image;
  final int distance;

  PrinterEntity copyWith({
    String id,
    String name,
    String status,
    String description,
    String image,
    int distance,
  }) {
    return new PrinterEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      description: description ?? this.description,
      image: image ?? this.image,
      distance: distance ?? this.distance,
    );
  }

  Map<String, Object> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'description': description,
      'image': image,
      'distance': distance,
    };
  }

  @override
  String toString() {
    return 'PrinterEntity{id: $id, name: $name, status: $status, description: $description, image: $image, distance: $distance}';
  }

  @override
  int get hashCode =>
    id.hashCode ^
    name.hashCode ^
    status.hashCode ^
    description.hashCode ^
    image.hashCode ^
    distance.hashCode;

  @override
  bool operator ==(dynamic other) =>
    identical(this, other) ||
    runtimeType == other.runtimeType &&
    id == other.id &&
    name == other.name &&
    status == other.name &&
    description == other.user &&
    image == other.image &&
    distance == other.distance;
}
