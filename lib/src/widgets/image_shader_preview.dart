part of flutter_image_filters;

class ImageShaderPreview extends StatelessWidget {
  final ShaderConfiguration configuration;
  final TextureSource texture;
  final BoxFit fix;
  final BlendMode blendMode;

  const ImageShaderPreview({
    super.key,
    required this.configuration,
    required this.texture,
    this.blendMode = BlendMode.src,
    this.fix = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    final cachedProgram = configuration._internalProgram;
    if (cachedProgram != null) {
      if (fix == BoxFit.contain) {
        return AspectRatio(
          aspectRatio: texture.aspectRatio,
          child: CustomPaint(
            painter: ImageShaderPainter(
              cachedProgram,
              texture,
              configuration,
              blendMode: blendMode,
            ),
          ),
        );
      }
      return SizedBox.expand(
        child: CustomPaint(
          painter: ImageShaderPainter(
            cachedProgram,
            texture,
            configuration,
            blendMode: blendMode,
          ),
        ),
      );
    }
    return FutureBuilder<void>(
      future: Future.value(configuration.prepare()),
      builder: ((context, snapshot) {
        if (snapshot.hasError && kDebugMode) {
          return SingleChildScrollView(
            child: Text(snapshot.error.toString()),
          );
        }
        final shaderProgram = configuration._internalProgram;
        if (shaderProgram == null) {
          return const CircularProgressIndicator();
        }
        if (fix == BoxFit.contain) {
          return AspectRatio(
            aspectRatio: texture.aspectRatio,
            child: CustomPaint(
              painter: ImageShaderPainter(
                shaderProgram,
                texture,
                configuration,
                blendMode: blendMode,
              ),
            ),
          );
        }

        return SizedBox.expand(
          child: CustomPaint(
            painter: ImageShaderPainter(
              shaderProgram,
              texture,
              configuration,
              blendMode: blendMode,
            ),
          ),
        );
      }),
    );
  }
}
