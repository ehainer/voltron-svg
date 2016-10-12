require "voltron"

module Voltron
  module Svg
    class Tag

      include ActionView::Helpers

      def initialize(file, options={})
        options = options.symbolize_keys
        @file = file
        @options = options
        setup
      end

      def setup
        # If a size is specified, extract it's width/height
        @options[:width], @options[:height] = extract_dimensions(@options.delete(:size)) if @options[:size]

        # Ensure the svg extension is added if a symbol was provided for icon name
        @options[:extension] ||= :svg if @file.is_a?(Symbol)

        # Set the default quality
        @options[:quality] ||= Voltron.config.svg.quality

        # Generate the SVG (if custom color) and the corresponding fallback PNG, only if running in environment that allows conversion
        create_png if Voltron.config.svg.buildable?
      end

      def image_path
        # Get the fallback image path, either using the :fallback option if specified, or use the default generated png
        asset_path (@options[:fallback] || name(:png, size.to_s.downcase, color.upcase))
      end

      def svg_path
        asset_path name(@options[:extension], color.upcase)
      end

      def asset_path(filename)
        if Rails.application.config.assets.digest && Rails.application.config.assets.compile
          filename = Rails.application.assets.find_asset(filename).try(:digest_path) || filename
        end

        File.join(Rails.application.config.assets.prefix, filename)
      end

      # Return the html <img /> tag with the needed attributes
      def html
        image_tag svg_path, attributes
      end

      def attributes
        @options[:alt] ||= @file
        @options[:data] ||= {}
        @options[:data].merge!({ svg: true, size: size, fallback: image_path })
        @options.reject { |k,v| [:color, :fallback, :quality, :extension].include?(k) }
      end

      # Try to get the SVG file
      def svg
        begin
          @svg ||= ::MiniMagick::Image.open(to_svg_path)
        rescue ::MiniMagick::Error => e
        rescue ::Errno::ENOENT => e
          false
        end
      end

      # Attempt to get width from specified options, then from the source SVG file itself, and ultimately say the width is 16
      def width
        (@options[:width] || svg.try(:width) || 16).to_i
      end

      # Attempt to get height from specified options, then from the source SVG file itself, and ultimately say the height is 16
      def height
        (@options[:height] || svg.try(:height) || 16).to_i
      end

      # Get the color specified, if any, removing anything that's not alphanumeric for use in the generated filename
      def color
        @options[:color].to_s.gsub(/[^\dA-Z]/i, "")
      end

      def size
        "#{width}x#{height}"
      end

      def name(extension = nil, *opts)
        filename = @file.to_s

        if extension.nil? && (matches = filename.match(/\.(.*)$/i))
          extension = matches[1]
        end

        # If called like `svg_tag :my_icon`, convert to "my-icon"
        # If the filename "my_icon" is actually needed, call `svg_tag "my_icon"` (don't use symbol)
        filename = filename.dasherize if @file.is_a?(Symbol)

        pieces = filename.split(".").insert(1, opts).flatten

        # Add the extension if it doesn't end with the extension, if nil it will just get removed on the next line
        pieces << extension unless pieces[-1] == extension.to_s

        # Remove anything that might be empty or nil
        pieces.reject!(&:blank?)

        # Put all the pieces together, get a name like file.50x50.RED.png
        pieces.join(".")
      end

      # The fallback image path for the SVG
      def fallback_path
        File.join Voltron.config.svg.image_directory, name(:png, size.to_s.downcase, color.upcase)
      end

      # The source SVG path
      def from_svg_path
        File.join Voltron.config.svg.source_directory, name(@options[:extension])
      end

      # The SVG we'll ultimately use to generate the PNG, if no color was specified this will be the same as `from_svg_path`
      def to_svg_path
        File.join Voltron.config.svg.source_directory, name(@options[:extension], color.upcase)
      end

      # If a color is specified and we haven't already created the colorized SVG, generate it
      def create_svg
        if !color.blank? && !File.exists?(to_svg_path)
          # Get the svg contents
          content = File.read(from_svg_path)

          # Set the color of any path/stroke in the svg
          content.gsub! /fill=\"[^\"]+\"/, "fill=\"#{@options[:color]}\""
          content.gsub! /stroke=\"[^\"]+\"/, "stroke=\"#{@options[:color]}\""

          # Write the new svg file
          File.open(to_svg_path, "w") { |f| f.puts content }

          Rails.application.assets_manifest.compile name(:svg, color.upcase)

          Voltron.log "Generated SVG: #{app_path(from_svg_path)} -> #{app_path(to_svg_path)}", "SVG", :light_magenta
        end
      end

      # If we haven't done so already, create the PNG from the SVG source file
      def create_png
        return false if File.exists?(fallback_path)

        begin
          # Ensure the SVG we will convert to a PNG exists first
          create_svg

          # Then convert the SVG to a PNG
          ::MiniMagick::Tool::Convert.new do |convert|
            convert.merge! ["-gravity", "center"]
            convert.merge! ["-background", "none"]
            convert.merge! ["-quality", @options[:quality]]
            convert.merge! ["-density", density]
            convert.merge! ["-resize", size]
            convert.merge! ["-extent", size]
            convert << to_svg_path
            convert << fallback_path
            convert
          end

          Rails.application.assets_manifest.compile name(:png, size.to_s.downcase, color.upcase)

          Voltron.log "Generated PNG: #{app_path(to_svg_path)} -> #{app_path(fallback_path)}", "SVG", :light_magenta
          true
        rescue ::MiniMagick::Error => e
          Voltron.log e.message, "SVG", :red
          false
        end
      end

      protected

        # Get the density of the image so the possibly enlarged SVG -> PNG does not look blurry
        # Basically just the svg's original width (or 1, if an error) multiplied by the largest side
        def density
          if width > height
            "#{(svg.try(:width) || 1)*width}x#{(svg.try(:height) || 1)*width}"
          else
            "#{(svg.try(:width) || 1)*height}x#{(svg.try(:height) || 1)*height}"
          end
        end

        # Only used for logging, slim down the path to `path` by getting rid of everything leading up to the rails root directory
        def app_path(path)
          path.sub(Rails.root.to_s, "")
        end

        def extract_dimensions(size)
          size = size.to_s
          if size =~ %r{\A\d+x\d+\z}
            size.split("x")
          elsif size =~ %r{\A\d+\z}
            [size, size]
          end
        end

    end
  end
end