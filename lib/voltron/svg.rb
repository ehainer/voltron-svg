require "voltron/svg/version"
require "voltron/svg/tag"
require "voltron/config/svg"
require "mini_magick"
require "sass/rails"

module Voltron
  module Svg

    module SassHelpers
      def svg_icon(source, options={})
        puts options
        puts options.value
        options = options.map { |k,v| { k => v.value } }.reduce(Hash.new, :merge)

        tag = Voltron::Svg::Tag.new(source.value, options)

        ::Sass::Script::String.new "url(\"#{tag.image_path}\");\nbackground-image: url(\"#{tag.svg_path}\"), linear-gradient(transparent, transparent)"
      end

      ::Sass::Script::Functions.declare :svg_icon, [:source], var_args: true, var_kwargs: true
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