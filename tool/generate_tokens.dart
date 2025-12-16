import 'dart:convert';
import 'dart:io';

/// Generates Dart token files from ZeroHeight JSON token exports.
///
/// Usage: dart run tool/generate_tokens.dart
void main() async {
  final tokensDir = Directory('lib/tokens');

  if (!tokensDir.existsSync()) {
    print('Error: lib/tokens directory not found');
    exit(1);
  }

  final jsonFiles = tokensDir.listSync().whereType<File>().where(
    (f) => f.path.endsWith('.json'),
  );

  if (jsonFiles.isEmpty) {
    print('No JSON token files found in lib/tokens/');
    exit(0);
  }

  for (final jsonFile in jsonFiles) {
    await processTokenFile(jsonFile);
  }

  print('Token generation complete!');
}

Future<void> processTokenFile(File jsonFile) async {
  final fileName = jsonFile.path.split('/').last;
  final baseName = fileName.replaceAll('.json', '');
  final className = _toClassName(baseName);
  final dartFileName = '${_toSnakeCase(baseName)}.dart';
  final dartFilePath = 'lib/tokens/$dartFileName';

  print('Processing: $fileName -> $dartFileName');

  final jsonContent = await jsonFile.readAsString();
  final Map<String, dynamic> tokens = json.decode(jsonContent);

  final buffer = StringBuffer();
  buffer.writeln("// AUTO-GENERATED FILE - DO NOT EDIT");
  buffer.writeln("// Generated from: $fileName");
  buffer.writeln("// Run 'dart run tool/generate_tokens.dart' to regenerate");
  buffer.writeln();
  buffer.writeln("import 'dart:ui';");
  buffer.writeln();
  buffer.writeln("class $className {");
  buffer.writeln("  $className._();");
  buffer.writeln();

  _processTokens(tokens, '', buffer);

  buffer.writeln("}");

  await File(dartFilePath).writeAsString(buffer.toString());
  print('  Generated: $dartFilePath');
}

void _processTokens(
  Map<String, dynamic> tokens,
  String prefix,
  StringBuffer buffer,
) {
  tokens.forEach((key, value) {
    if (value is Map<String, dynamic>) {
      if (value.containsKey('\$type') && value.containsKey('\$value')) {
        final type = value['\$type'] as String;
        final tokenValue = value['\$value'];
        final cleanKey = _cleanKey(key);
        final varName = _toVariableName(prefix, cleanKey);

        final dartValue = _convertValue(type, tokenValue);
        if (dartValue != null) {
          buffer.writeln("  static const $varName = $dartValue;");
        }
      } else {
        final newPrefix = prefix.isEmpty ? key : '$prefix$key';
        _processTokens(value, newPrefix, buffer);
      }
    }
  });
}

/// Clean up keys like from scale property figma "100(4)" -> "100", "None (0)" -> "None"
String _cleanKey(String key) {
  return key.replaceAll(RegExp(r'\s*\([^)]*\)'), '').trim();
}

String? _convertValue(String type, dynamic value) {
  switch (type) {
    case 'color':
      return _convertColor(value.toString());
    case 'number':
      if (value is num) {
        return value.toString();
      }
      // Handle reference values like "{Scale.400(16)}" -> extract 16
      if (value is String) {
        final match = RegExp(r'\((\d+)\)').firstMatch(value);
        if (match != null) {
          return match.group(1);
        }
      }
      return null;
    case 'string':
      return '"$value"';
    default:
      return null;
  }
}

String _convertColor(String hexColor) {
  // Handle formats: #RRGGBB, #RRGGBBAA
  var hex = hexColor.replaceAll('#', '').toUpperCase();

  if (hex.length == 6) {
    hex = 'FF$hex'; // Add full opacity
  } else if (hex.length == 8) {
    // Move alpha to front (CSS format: RRGGBBAA -> Dart format: AARRGGBB)
    hex = '${hex.substring(6)}${hex.substring(0, 6)}';
  }

  return 'Color(0x$hex)';
}

String _toClassName(String name) {
  // token_Premitive_Mode1 -> TokenPrimitiveMode1
  return name
      .split(RegExp(r'[_\-\s]+'))
      .map(
        (part) => part.isEmpty
            ? ''
            : '${part[0].toUpperCase()}${part.substring(1).toLowerCase()}',
      )
      .join('')
      .replaceAll('Premitive', 'Primitive'); // Fix typo
}

String _toSnakeCase(String name) {
  // TokenPrimitiveMode1 -> token_primitive_mode1
  return name
      .replaceAllMapped(
        RegExp(r'([A-Z])'),
        (m) => '_${m.group(1)!.toLowerCase()}',
      )
      .replaceAll(RegExp(r'^_'), '')
      .replaceAll('__', '_')
      .replaceAll('premitive', 'primitive') // Fix typo
      .toLowerCase();
}

String _toVariableName(String prefix, String key) {
  // Combine prefix and key, handle special characters
  final combined = '$prefix$key'
      .replaceAll(RegExp(r'[^a-zA-Z0-9]'), ' ')
      .trim()
      .split(RegExp(r'\s+'))
      .where((s) => s.isNotEmpty)
      .toList();

  if (combined.isEmpty) return 'unknown';

  // Convert to camelCase
  final first = combined.first.toLowerCase();
  final rest = combined
      .skip(1)
      .map(
        (s) => s.isEmpty
            ? ''
            : '${s[0].toUpperCase()}${s.substring(1).toLowerCase()}',
      )
      .join('');

  return '$first$rest';
}
