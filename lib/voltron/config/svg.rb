module Voltron
  class Config

    def svg
      @svg ||= Svg.new
    end

    class Svg

      attr_accessor :build_environment, :source_directory, :image_directory, :quality

      def initialize
        @quality ||= 90
        @build_environment ||= [:development]
        @source_directory ||= Rails.root.join("app", "assets", "svg")
        @image_directory ||= Rails.root.join("app", "assets", "images")
      end

      def buildable?
        [build_environment].flatten.map(&:to_s).include?(Rails.env.to_s)
      end
    end
  end
end