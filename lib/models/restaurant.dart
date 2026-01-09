/// Model representing a restaurant/venue in the system.
/// This extends the concept of Venue to be more specific for multi-restaurant support.
class Restaurant {
  final String id;
  final String name;
  final String logoUrl;
  final String? coverImageUrl;
  final String? coverImageBlurHash;

  const Restaurant({
    required this.id,
    required this.name,
    required this.logoUrl,
    this.coverImageUrl,
    this.coverImageBlurHash,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] as String,
      name: json['name'] as String,
      logoUrl: json['logo_url'] as String,
      coverImageUrl: json['cover_image_url'] as String?,
      coverImageBlurHash: json['cover_image_blur_hash'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo_url': logoUrl,
      'cover_image_url': coverImageUrl,
      'cover_image_blur_hash': coverImageBlurHash,
    };
  }
}

