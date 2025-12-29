import 'package:paygoo/models/venue.dart';

class VenueMock {
  VenueMock._();

  static const Venue tavernaRacilor = Venue(
    id: '1',
    name: 'Taverna Racilor',
    logoUrl: 'assets/images/logos/Logo1.png',
    tableNumber: 'Table: 8',
  );

  static const Venue restaurantExemplu = Venue(
    id: '2',
    name: 'Restaurant Exemplu',
    logoUrl: 'assets/images/logos/Logo1.png',
    tableNumber: 'Table: 12',
  );

  static const List<Venue> allVenues = [
    tavernaRacilor,
    restaurantExemplu,
  ];
}

