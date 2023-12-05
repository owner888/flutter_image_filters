part of flutter_image_filters;

class HighlightShadowShaderConfiguration extends ShaderConfiguration {
  final NumberParameter _shadows;
  final NumberParameter _highlights;

  HighlightShadowShaderConfiguration()
      : _shadows = ShaderRangeNumberParameter(
          'inputShadows',
          'shadows',
          0.0,
          0,
          min: 0.0,
          max: 1.0,
        ),
        _highlights = ShaderRangeNumberParameter(
          'inputHighlights',
          'highlights',
          1.0,
          1,
          min: 0.0,
          max: 1.0,
        ),
        super([0.0, 1.0]);

  set shadows(double value) {
    _shadows.value = value;
    _shadows.update(this);
  }

  set highlights(double value) {
    _highlights.value = value;
    _highlights.update(this);
  }

  @override
  List<ConfigurationParameter> get parameters => [_shadows, _highlights];
}
