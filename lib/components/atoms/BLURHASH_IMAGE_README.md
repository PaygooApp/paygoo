# BlurHashImage Component

A reusable Flutter widget that displays images with BlurHash placeholders. Provides a smooth loading experience by showing a blurred preview while the actual image loads.

## Overview

BlurHash is a compact representation of a placeholder for an image. It encodes the image into a short string (~20-30 characters) that can be stored in a database and transmitted instantly with API responses. This eliminates layout shifts and provides immediate visual feedback while images load from CDN/network.

## Installation

The component uses the `flutter_blurhash` package which should already be installed:

```yaml
dependencies:
  flutter_blurhash: ^0.9.1
```

## Basic Usage

### Asset Images (Local)

```dart
import 'package:paygoo/components/atoms/blurhash_image.dart';

BlurHashImage(
  blurHash: 'LCF~]}E29axtD%kCMxWB-oxuRjt6',
  imagePath: 'assets/images/cover/background_app.png',
  height: 200,
  width: double.infinity,
)
```

### Network Images (CDN)

```dart
BlurHashImage(
  blurHash: 'LKO2?U%2Tw=w]~RBVZRi',
  imagePath: 'https://cdn.example.com/images/cover.jpg',
  source: BlurHashImageSource.network,
  height: 200,
  width: double.infinity,
)
```

## Parameters

| Parameter          | Type                       | Default          | Description                                |
| ------------------ | -------------------------- | ---------------- | ------------------------------------------ |
| `blurHash`         | `String`                   | **required**     | The BlurHash string for the placeholder    |
| `imagePath`        | `String`                   | **required**     | Asset path or URL depending on `source`    |
| `source`           | `BlurHashImageSource`      | `.asset`         | Image source type: `.asset` or `.network`  |
| `fit`              | `BoxFit`                   | `.cover`         | How the image should fit within its bounds |
| `alignment`        | `Alignment`                | `.center`        | Alignment of the image within its bounds   |
| `width`            | `double?`                  | `null`           | Width constraint for the widget            |
| `height`           | `double?`                  | `null`           | Height constraint for the widget           |
| `duration`         | `Duration`                 | `300ms`          | Fade-in animation duration                 |
| `curve`            | `Curve`                    | `Curves.easeOut` | Animation curve for the fade effect        |
| `decodingWidth`    | `int`                      | `32`             | BlurHash decode width (lower = faster)     |
| `decodingHeight`   | `int`                      | `32`             | BlurHash decode height (lower = faster)    |
| `optimizationMode` | `BlurHashOptimizationMode` | `.standard`      | Decoding optimization mode                 |
| `errorBuilder`     | `Widget Function(...)`     | `null`           | Custom error widget builder                |

## Optimization Modes

The `flutter_blurhash` package offers three optimization modes:

```dart
// Standard - balanced performance and quality
BlurHashImage(
  blurHash: hash,
  imagePath: url,
  optimizationMode: BlurHashOptimizationMode.standard,
)

// Approximation - fastest, slightly darker results
BlurHashImage(
  blurHash: hash,
  imagePath: url,
  optimizationMode: BlurHashOptimizationMode.approximation,
)

// None - original algorithm (backward compatibility)
BlurHashImage(
  blurHash: hash,
  imagePath: url,
  optimizationMode: BlurHashOptimizationMode.none,
)
```

## Generating BlurHash Strings

### For Development/Testing

Use the online tool: https://blurha.sh

1. Upload your image
2. Copy the generated hash string
3. Use it in your widget

### For Production (Backend)

BlurHash should be generated server-side when images are uploaded:

**Node.js example:**

```javascript
const { encode } = require("blurhash");
const sharp = require("sharp");

async function generateBlurHash(imagePath) {
  const { data, info } = await sharp(imagePath)
    .raw()
    .ensureAlpha()
    .resize(32, 32, { fit: "inside" })
    .toBuffer({ resolveWithObject: true });

  return encode(
    new Uint8ClampedArray(data),
    info.width,
    info.height,
    4, // x components
    3 // y components
  );
}
```

**Python example:**

```python
import blurhash
from PIL import Image

def generate_blurhash(image_path):
    with Image.open(image_path) as img:
        return blurhash.encode(img, x_components=4, y_components=3)
```

## Current Implementation

### File Location

```
lib/components/atoms/blurhash_image.dart
```

### Architecture

```
BlurHashImage (StatelessWidget)
├── SizedBox (width/height constraints)
│   └── Stack
│       ├── BlurHash (placeholder - always behind)
│       └── _AssetImageWithFade or _NetworkImageWithFade
│           └── AnimatedOpacity (fade-in when loaded)
│               └── Image.asset or Image.network
```

### How It Works

1. Widget renders immediately with BlurHash placeholder
2. Image starts loading in background (precacheImage)
3. When image loads, AnimatedOpacity fades it in
4. BlurHash stays behind but becomes invisible under the image

## Integration Examples

### StickyVenueHeader (Current Implementation)

```dart
StickyVenueHeader(
  scrollController: _scrollController,
  venue: venue,
  coverImageBlurHash: 'LCF~]}E29axtD%kCMxWB-oxuRjt6',  // Optional
  builder: (context, coverSection, stickyOverlay) {
    // ...
  },
)
```

### Menu Item Card (Future)

```dart
class MenuItemCard extends StatelessWidget {
  final MenuItem item;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BlurHashImage(
              blurHash: item.imageBlurHash,
              imagePath: item.imageUrl,
              source: BlurHashImageSource.network,
              height: 120,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Text(item.name),
          ),
        ],
      ),
    );
  }
}
```

### Venue Logo (Circular)

```dart
ClipOval(
  child: BlurHashImage(
    blurHash: venue.logoBlurHash,
    imagePath: venue.logoUrl,
    source: BlurHashImageSource.network,
    width: 48,
    height: 48,
  ),
)
```

## Data Model Recommendations

### Venue Model (with BlurHash support)

```dart
class Venue {
  final String id;
  final String name;

  // Logo
  final String logoUrl;
  final String? logoBlurHash;

  // Cover Image
  final String? coverImageUrl;
  final String? coverImageBlurHash;

  // ... other fields

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      id: json['id'],
      name: json['name'],
      logoUrl: json['logoUrl'],
      logoBlurHash: json['logoBlurHash'],
      coverImageUrl: json['coverImageUrl'],
      coverImageBlurHash: json['coverImageBlurHash'],
    );
  }
}
```

### MenuItem Model (for menu feature)

```dart
class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String imageBlurHash;
  final String? category;

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      imageUrl: json['imageUrl'],
      imageBlurHash: json['imageBlurHash'],
      category: json['category'],
    );
  }
}
```

## API Response Format

Your backend should return BlurHash alongside every image URL:

```json
{
  "venue": {
    "id": "venue_123",
    "name": "Taverna Racilor",
    "logoUrl": "https://cdn.paygoo.com/venues/123/logo.png",
    "logoBlurHash": "L5H2EC=PM+yV0g-mq.wG9c010J}I",
    "coverImageUrl": "https://cdn.paygoo.com/venues/123/cover.jpg",
    "coverImageBlurHash": "LCF~]}E29axtD%kCMxWB-oxuRjt6"
  },
  "menuItems": [
    {
      "id": "item_1",
      "name": "Pasta Carbonara",
      "description": "Classic Italian pasta with bacon and egg",
      "price": 24.99,
      "imageUrl": "https://cdn.paygoo.com/items/pasta.jpg",
      "imageBlurHash": "LKO2?U%2Tw=w]~RBVZRi*.7S$yoL"
    },
    {
      "id": "item_2",
      "name": "Margherita Pizza",
      "description": "Fresh tomato, mozzarella, and basil",
      "price": 18.99,
      "imageUrl": "https://cdn.paygoo.com/items/pizza.jpg",
      "imageBlurHash": "LGF5]+Yk^6#M@-5c,1J5@[or[Q6."
    }
  ]
}
```

## Performance Tips

### For Lists/Grids (Menu scrolling)

1. **Use smaller decode dimensions** for thumbnails:

   ```dart
   BlurHashImage(
     blurHash: hash,
     imagePath: url,
     decodingWidth: 16,  // Smaller = faster decode
     decodingHeight: 16,
   )
   ```

2. **Use approximation mode** for faster rendering:

   ```dart
   BlurHashImage(
     blurHash: hash,
     imagePath: url,
     optimizationMode: BlurHashOptimizationMode.approximation,
   )
   ```

3. **Keep fade duration short** in production:
   ```dart
   BlurHashImage(
     blurHash: hash,
     imagePath: url,
     duration: Duration(milliseconds: 200),
   )
   ```

### Image Caching

For production with many network images, consider adding `cached_network_image`:

```yaml
dependencies:
  cached_network_image: ^3.3.0
```

The component can be extended to use `CachedNetworkImage` for better caching.

## Error Handling

Provide a custom error widget when images fail to load:

```dart
BlurHashImage(
  blurHash: hash,
  imagePath: url,
  source: BlurHashImageSource.network,
  errorBuilder: (context, error, stackTrace) {
    return Container(
      color: Colors.grey[200],
      child: Icon(Icons.broken_image, color: Colors.grey),
    );
  },
)
```

If no errorBuilder is provided, the BlurHash placeholder remains visible on error.

## Limitations

1. **No encoding support** - BlurHash strings must be generated externally (backend or blurha.sh)
2. **No caching** - Network images are not cached (consider adding cached_network_image)
3. **Single image** - Does not support image galleries or multiple images

## Future Enhancements

Potential improvements for marketplace scale:

1. **CachedNetworkImage integration** - Add disk caching for network images
2. **Shimmer effect option** - Alternative to static BlurHash
3. **Progressive loading** - Load low-res then high-res
4. **Retry mechanism** - Auto-retry failed network requests
5. **Placeholder fallback** - Default BlurHash when none provided
