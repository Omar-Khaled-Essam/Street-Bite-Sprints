import '../../domain/entities/vendor_entity.dart';

class VendorCatalog {
  VendorCatalog._();

  static const List<VendorEntity> nearby = [
    VendorEntity(
      id: 'v1',
      name: 'Sabor Mexicano Grill',
      cuisine: 'Mexican',
      rating: 4.8,
      latitude: 30.0444,
      longitude: 31.2357,
      city: 'Cairo',
    ),
    VendorEntity(
      id: 'v2',
      name: 'Nile Street Kitchen',
      cuisine: 'Egyptian',
      rating: 4.6,
      latitude: 31.2001,
      longitude: 29.9187,
      city: 'Alexandria',
    ),
    VendorEntity(
      id: 'v3',
      name: 'Dubai Spice Cart',
      cuisine: 'Emirati',
      rating: 4.7,
      latitude: 25.2048,
      longitude: 55.2708,
      city: 'Dubai',
    ),
    VendorEntity(
      id: 'v4',
      name: 'Amman Shawarma House',
      cuisine: 'Levantine',
      rating: 4.5,
      latitude: 31.9454,
      longitude: 35.9284,
      city: 'Amman',
    ),
    VendorEntity(
      id: 'v5',
      name: 'Istanbul Grill Night',
      cuisine: 'Turkish',
      rating: 4.9,
      latitude: 41.0082,
      longitude: 28.9784,
      city: 'Istanbul',
    ),
  ];
}
