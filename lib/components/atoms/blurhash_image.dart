import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

/// Image source type for BlurHashImage widget
enum BlurHashImageSource {
  /// Load image from assets
  asset,

  /// Load image from network
  network,
}

/// A widget that displays an image with a BlurHash placeholder.
///
/// Shows the BlurHash while the image is loading, then smoothly
/// transitions to the actual image once it's ready.
///
/// This widget is intended for images only, not icons.
class BlurHashImage extends StatelessWidget {
  const BlurHashImage({
    super.key,
    required this.blurHash,
    required this.imagePath,
    this.source = BlurHashImageSource.asset,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.width,
    this.height,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeOut,
    this.decodingWidth = 32,
    this.decodingHeight = 32,
    this.optimizationMode = BlurHashOptimizationMode.standard,
    this.errorBuilder,
  });

  /// The BlurHash string for the placeholder.
  /// Generate using https://blurha.sh or similar tools.
  final String blurHash;

  /// The image path (asset path or URL depending on [source]).
  final String imagePath;

  /// Whether to load from assets or network.
  final BlurHashImageSource source;

  /// How the image should be inscribed into the box.
  final BoxFit fit;

  /// How to align the image within its bounds.
  final Alignment alignment;

  /// Width constraint for the widget.
  final double? width;

  /// Height constraint for the widget.
  final double? height;

  /// Duration of the fade-in animation when the image loads.
  final Duration duration;

  /// Animation curve for the fade-in effect.
  final Curve curve;

  /// Width for decoding the BlurHash (lower = faster, higher = more detail).
  final int decodingWidth;

  /// Height for decoding the BlurHash (lower = faster, higher = more detail).
  final int decodingHeight;

  /// Optimization mode for BlurHash decoding.
  final BlurHashOptimizationMode optimizationMode;

  /// Optional error builder when image fails to load.
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // BlurHash placeholder (always behind)
          BlurHash(
            hash: blurHash,
            decodingWidth: decodingWidth,
            decodingHeight: decodingHeight,
            imageFit: fit,
            optimizationMode: optimizationMode,
          ),
          // Actual image with fade-in
          _buildImage(),
        ],
      ),
    );
  }

  Widget _buildImage() {
    switch (source) {
      case BlurHashImageSource.asset:
        return _AssetImageWithFade(
          imagePath: imagePath,
          fit: fit,
          alignment: alignment,
          duration: duration,
          curve: curve,
          errorBuilder: errorBuilder,
        );
      case BlurHashImageSource.network:
        return _NetworkImageWithFade(
          imagePath: imagePath,
          fit: fit,
          alignment: alignment,
          duration: duration,
          curve: curve,
          errorBuilder: errorBuilder,
        );
    }
  }
}

/// Asset image that fades in when loaded
class _AssetImageWithFade extends StatefulWidget {
  const _AssetImageWithFade({
    required this.imagePath,
    required this.fit,
    required this.alignment,
    required this.duration,
    required this.curve,
    this.errorBuilder,
  });

  final String imagePath;
  final BoxFit fit;
  final Alignment alignment;
  final Duration duration;
  final Curve curve;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  @override
  State<_AssetImageWithFade> createState() => _AssetImageWithFadeState();
}

class _AssetImageWithFadeState extends State<_AssetImageWithFade> {
  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _precacheImage();
  }

  Future<void> _precacheImage() async {
    try {
      await precacheImage(AssetImage(widget.imagePath), context);
      if (mounted) {
        setState(() => _isLoaded = true);
      }
    } catch (_) {
      // Image failed to load, will show error or stay on blur
      if (mounted) {
        setState(() => _isLoaded = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _isLoaded ? 1.0 : 0.0,
      duration: widget.duration,
      curve: widget.curve,
      child: Image.asset(
        widget.imagePath,
        fit: widget.fit,
        alignment: widget.alignment,
        errorBuilder: widget.errorBuilder,
      ),
    );
  }
}

/// Network image that fades in when loaded
class _NetworkImageWithFade extends StatefulWidget {
  const _NetworkImageWithFade({
    required this.imagePath,
    required this.fit,
    required this.alignment,
    required this.duration,
    required this.curve,
    this.errorBuilder,
  });

  final String imagePath;
  final BoxFit fit;
  final Alignment alignment;
  final Duration duration;
  final Curve curve;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  @override
  State<_NetworkImageWithFade> createState() => _NetworkImageWithFadeState();
}

class _NetworkImageWithFadeState extends State<_NetworkImageWithFade> {
  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _precacheImage();
  }

  Future<void> _precacheImage() async {
    try {
      await precacheImage(NetworkImage(widget.imagePath), context);
      if (mounted) {
        setState(() => _isLoaded = true);
      }
    } catch (_) {
      // Image failed to load, will show error or stay on blur
      if (mounted) {
        setState(() => _isLoaded = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _isLoaded ? 1.0 : 0.0,
      duration: widget.duration,
      curve: widget.curve,
      child: Image.network(
        widget.imagePath,
        fit: widget.fit,
        alignment: widget.alignment,
        errorBuilder: widget.errorBuilder,
      ),
    );
  }
}
