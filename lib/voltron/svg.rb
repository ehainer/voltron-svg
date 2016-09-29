require "voltron/svg/version"
require "voltron/svg/tag"
require "voltron/config/svg"
require "mini_magick"
require "sass/rails"

module Voltron
  module Svg

    module SassHelpers
      def svg_icon(source, options={})
        options = map_options(options)
        raise options
        tag = Voltron::Svg::Tag.new(source.value, options)

        ::Sass::Script::String.new "url(\"#{tag.image_path}\");\nbackground-image: url(\"#{tag.svg_path}\"), linear-gradient(transparent, transparent)"
      end

      protected
        def map_options(options={})
          ::Sass::Util.map_hash(options) do |key, value|
            [key.to_sym, value.respond_to?(:value) ? value.value : value.to_s]
          end
        end

      ::Sass::Script::Functions.declare :svg_icon, [:source], var_kwargs: true
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