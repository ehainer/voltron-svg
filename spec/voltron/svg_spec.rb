require "rails_helper"
require "sass/rails"

describe Voltron::Svg do

  include Voltron::Svg::ViewHelpers

  include Voltron::Svg::SassHelpers

  it "has a version number" do
    expect(Voltron::Svg::VERSION).not_to be nil
  end

  it "should generate an img tag for given svg" do
    expect(svg_tag(:airplane)).to match(/^<img.*/i)
  end

  it "should output background css for svg fallback" do
    expect(svg_icon(:airplane)).to_not be_blank
  end

end
