require "rails_helper"

describe Voltron::Svg do

  include Voltron::Svg::ViewHelpers

  include Voltron::Svg::SassHelpers

  it "has a version number" do
    expect(Voltron::Svg::VERSION).not_to be nil
  end

  it "should generate an img tag for given svg" do
    expect(svg_tag(:airplane)).to match(/<img data\-svg="true" data\-size="16x16" data\-image=".*airplane\.16x16\-[A-Z0-9]+\.png" src=".*airplane\-[A-Z0-9]+\.svg" alt="Airplane" \/>/i)
  end

  it "should output background css for svg fallback" do
    expect(svg_icon(:airplane)).to_not be_blank
  end

end
