module Voltron
  module Svg
    module Generators
      class InstallGenerator < Rails::Generators::Base

        desc "Add Voltron SVG initializer"

        def inject_initializer

          voltron_initialzer_path = Rails.root.join("config", "initializers", "voltron.rb")

          unless File.exist? voltron_initialzer_path
            unless system("cd #{Rails.root.to_s} && rails generate voltron:install")
              puts "Voltron initializer does not exist. Please ensure you have the 'voltron' gem installed and run `rails g voltron:install` to create it"
              return false
            end
          end

          current_initiailzer = File.read voltron_initialzer_path

          unless current_initiailzer.match(Regexp.new(/# === Voltron SVG Configuration ===/))
            inject_into_file(voltron_initialzer_path, after: "Voltron.setup do |config|\n") do
<<-CONTENT

  # === Voltron SVG Configuration ===

  # The directory that contains SVG icons from which to create PNG's
  # config.svg.source_directory = Rails.root.join("app", "assets", "svg")

  # The directory where generated fallback images for SVG's should reside
  # config.svg.image_directory = Rails.root.join("app", "assets", "images")

  # The environment(s) that svg -> png generation can occur in. Defaults to "development"
  # Can specify either a single environment or an array of environments. NOT recommended for production
  # config.svg.build_environment << :development

  # The quality (0-100) of generated PNG's, can be overridden in SASS using:
  # svg-icon(icon, $quality: 100) or in the view helper:
  # svg_tag(:icon, quality: 100)
  # config.svg.quality = 90
CONTENT
            end
          end
        end
      end
    end
  end
end