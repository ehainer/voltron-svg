require "voltron/svg/version"
require "voltron/svg/tag"
require "voltron/config/svg"
require "mini_magick"
require "sass/rails"

module Voltron
  module Svg

    module SassHelpers
      def svg_icon(source, **options)
        options = options.symbolize_keys.compact
        puts options.to_yaml
        tag = Voltron::Svg::Tag.new(source, options)

        Sass::Script::Value::String.new "url(\"#{tag.image_path}\");\nbackground-image: url(\"#{tag.svg_path}\"), linear-gradient(transparent, transparent)"
      end

      Sass::Script::Functions.declare :svg_icon, [], var_args: true, var_kwargs: true
    end

    module ViewHelpers
      def svg_tag(source, options={})
        tag = Voltron::Svg::Tag.new(source, options)
        tag.html
      end
    end

  end
end

require "voltron/svg/railtie" if defined?(Rails)