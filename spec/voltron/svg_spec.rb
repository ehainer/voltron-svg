require "rails_helper"
require "sass/rails"

describe Voltron::Svg do

  include Voltron::Svg::ViewHelpers

  include Voltron::Svg::SassHelpers

  it "has a version number" do
    expect(Voltron::Svg::VERSION).not_to be nil
  end

  it "should generate an img tag for given svg" do
    expect(svg_tag(::Sass::Script::Value::String.new("airplane"))).to match(/^<img.*/i)
  end

  it "should output background css for svg fallback" do
    expect(svg_icon(::Sass::Script::Value::String.new("airplane"))).to_not be_blank
  end

  it "should convert sass value arguments to a hash" do
    options = { "size" => ::Sass::Script::Value::String.new("50x50", :string), "color" => ::Sass::Script::Value::Color.new([255, 255, 255], "white") }
    expect(map_options(options)).to eq({ size: "50x50", color: "white" })
  end

end
