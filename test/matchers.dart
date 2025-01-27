import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test/src/buffer_matcher.dart';
import 'package:image/image.dart' as img;

Future<void> expectFilteredSuccessfully(
  ShaderConfiguration configuration,
  TextureSource texture,
  String goldenKey, {
  String? configurationKey,
}) async {
  final image = await configuration.export(texture, texture.size);
  final bytes = await image.toByteData();

  expect(bytes, isNotNull);

  final persistedImage = img.Image.fromBytes(
    width: image.width,
    height: image.height,
    bytes: bytes!.buffer,
    numChannels: 4,
  );
  img.JpegEncoder encoder = img.JpegEncoder();
  final data = encoder.encode(persistedImage);
  final output = File(
    'test/goldens/shaders/${configurationKey ?? configuration.runtimeType}/$goldenKey',
  );
  try {
    await expectLater(data, bufferMatchesGoldenFile(output.absolute.path));
  } on FlutterError catch (e) {
    final diffTolerance = '$e'
        .contains(RegExp(r'Pixel test failed, [01]\.[0-9]+% diff detected'));
    if (diffTolerance) {
      debugPrint(e.message);
    } else {
      rethrow;
    }
  }
}
