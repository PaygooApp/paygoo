import 'package:paygoo/models/restaurant.dart';

/// Mock restaurant data for MVP testing
class RestaurantMock {
  RestaurantMock._();

  static const Restaurant tavernaRacilor = Restaurant(
    id: 'rest_001',
    name: 'Taverna Racilor',
    logoUrl: 'assets/images/logos/Logo1.png',
    coverImageUrl: 'assets/images/cover/background_app.png',
    coverImageBlurHash: 'LiMj{sRiM{V?ysf5t7ofpdogRkW=',
  );

  static const Restaurant restaurantExemplu = Restaurant(
    id: 'rest_002',
    name: 'Restaurant Exemplu',
    logoUrl: 'assets/images/logos/Logo1.png',
    coverImageUrl: 'assets/images/cover/background_app.png',
    coverImageBlurHash: 'LiMj{sRiM{V?ysf5t7ofpdogRkW=',
  );

  static const List<Restaurant> allRestaurants = [
    tavernaRacilor,
    restaurantExemplu,
  ];
}

