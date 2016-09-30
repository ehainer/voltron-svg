module Voltron
  module Svg
    class Engine < Rails::Engine
      initializer "voltron.svg.initialize" do
        ::ActionView::Base.send :include, ::Voltron::Svg::ViewHelpers
        ::Sass::Script::Functions.send :include, ::Voltron::Svg::SassHelpers
      end
    end
  end
end
