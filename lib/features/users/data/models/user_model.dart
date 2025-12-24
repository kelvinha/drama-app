import 'package:equatable/equatable.dart';

/// User Model
/// Model untuk data user dari JSONPlaceholder API

class UserModel extends Equatable {
  final int id;
  final String name;
  final String username;
  final String email;
  final String? phone;
  final String? website;
  final UserAddress? address;
  final UserCompany? company;

  const UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.phone,
    this.website,
    this.address,
    this.company,
  });

  /// From JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      website: json['website'] as String?,
      address: json['address'] != null
          ? UserAddress.fromJson(json['address'] as Map<String, dynamic>)
          : null,
      company: json['company'] != null
          ? UserCompany.fromJson(json['company'] as Map<String, dynamic>)
          : null,
    );
  }

  /// To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'phone': phone,
      'website': website,
      'address': address?.toJson(),
      'company': company?.toJson(),
    };
  }

  /// Copy with
  UserModel copyWith({
    int? id,
    String? name,
    String? username,
    String? email,
    String? phone,
    String? website,
    UserAddress? address,
    UserCompany? company,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      website: website ?? this.website,
      address: address ?? this.address,
      company: company ?? this.company,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    username,
    email,
    phone,
    website,
    address,
    company,
  ];
}

/// User Address Model
class UserAddress extends Equatable {
  final String street;
  final String suite;
  final String city;
  final String zipcode;
  final UserGeo? geo;

  const UserAddress({
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
    this.geo,
  });

  factory UserAddress.fromJson(Map<String, dynamic> json) {
    return UserAddress(
      street: json['street'] as String,
      suite: json['suite'] as String,
      city: json['city'] as String,
      zipcode: json['zipcode'] as String,
      geo: json['geo'] != null
          ? UserGeo.fromJson(json['geo'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'suite': suite,
      'city': city,
      'zipcode': zipcode,
      'geo': geo?.toJson(),
    };
  }

  @override
  List<Object?> get props => [street, suite, city, zipcode, geo];
}

/// User Geo Model
class UserGeo extends Equatable {
  final String lat;
  final String lng;

  const UserGeo({required this.lat, required this.lng});

  factory UserGeo.fromJson(Map<String, dynamic> json) {
    return UserGeo(lat: json['lat'] as String, lng: json['lng'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'lat': lat, 'lng': lng};
  }

  @override
  List<Object?> get props => [lat, lng];
}

/// User Company Model
class UserCompany extends Equatable {
  final String name;
  final String catchPhrase;
  final String bs;

  const UserCompany({
    required this.name,
    required this.catchPhrase,
    required this.bs,
  });

  factory UserCompany.fromJson(Map<String, dynamic> json) {
    return UserCompany(
      name: json['name'] as String,
      catchPhrase: json['catchPhrase'] as String,
      bs: json['bs'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'catchPhrase': catchPhrase, 'bs': bs};
  }

  @override
  List<Object?> get props => [name, catchPhrase, bs];
}
