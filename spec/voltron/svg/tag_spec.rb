require "rails_helper"
require "fileutils"

describe Voltron::Svg::Tag do

  let(:png) { File.expand_path("../../../railsapp/app/assets/images/airplane.16x16.png", __FILE__) }
  let(:svg) { File.expand_path("../../../railsapp/app/assets/svg/airplane.323A45.svg", __FILE__) }

  before(:each) do
    FileUtils.rm_rf(File.expand_path("../../../railsapp/public/assets/", __FILE__))
    FileUtils.rm_rf(Dir.glob(File.expand_path("../../../railsapp/app/assets/images/*.png", __FILE__)))
    FileUtils.rm(File.expand_path("../../../railsapp/app/assets/svg/airplane.323A45.svg", __FILE__)) if File.exists?(svg)
  end

  it "should have a width" do
    tag = Voltron::Svg::Tag.new(:airplane)
    expect(tag.width).to eq(16)
  end

  it "should have a height" do
    tag = Voltron::Svg::Tag.new(:airplane)
    expect(tag.height).to eq(16)
  end

  it "should create a png if buildable" do
    Voltron.config.svg.build_environment = :test
    tag = Voltron::Svg::Tag.new(:airplane)
    expect(File).to exist(png)
  end

  it "should not create a png if not buildable" do
    Voltron.config.svg.build_environment = :development
    tag = Voltron::Svg::Tag.new(:airplane)
    expect(File).to_not exist(png)
  end

  it "should have an svg source path even with made up filename" do
    tag = Voltron::Svg::Tag.new(:bologne)
    expect(tag.from_svg_path).to eq(Voltron.config.svg.source_directory.join("bologne.svg").to_s)
  end

  it "should dasherize and suffix svg names input as symbols" do
    tag = Voltron::Svg::Tag.new(:bologne_and_ham)
    expect(tag.from_svg_path).to eq(Voltron.config.svg.source_directory.join("bologne-and-ham.svg").to_s)
  end

  it "should not manipulate svg names input as strings" do
    tag = Voltron::Svg::Tag.new("bologne_and_ham")
    expect(tag.from_svg_path).to eq(Voltron.config.svg.source_directory.join("bologne_and_ham").to_s)
  end

  it "should determine the width and height by size" do
    tag = Voltron::Svg::Tag.new(:airplane, size: "52x48")
    expect(tag.size).to eq("52x48")
    expect(tag.width).to eq(52)
    expect(tag.height).to eq(48)

    tag = Voltron::Svg::Tag.new(:airplane, size: 88)
    expect(tag.size).to eq("88x88")
    expect(tag.width).to eq(88)
    expect(tag.height).to eq(88)
  end

  it "should create a colorized svg if color is specified" do
    tag = Voltron::Svg::Tag.new(:airplane, color: "#323A45")
    expect(File).to exist(svg)
  end

  it "should have img tag attributes" do
    tag = Voltron::Svg::Tag.new(:airplane)
    attrs = tag.attributes
    expect(attrs[:data][:svg]).to eq(true)
    expect(attrs[:data][:size]).to eq("16x16")
    expect(attrs[:data][:image]).to_not be_blank
  end

  it "should permit overriding the fallback image" do
    tag = Voltron::Svg::Tag.new(:airplane, fallback: "1.jpg")
    expect(tag.attributes[:data][:image]).to match(/1\-[A-Z0-9]+\.jpg$/i)
  end

  it "should not permit svg tag specific options in the img tag attributes" do
    tag = Voltron::Svg::Tag.new(:airplane, fallback: "1.jpg", color: "red", alt: "Plane")
    expect(tag.attributes).to_not have_key(:color)
    expect(tag.attributes).to_not have_key(:fallback)
    expect(tag.attributes).to have_key(:alt)
  end

  it "should have an img html tag" do
    tag = Voltron::Svg::Tag.new(:airplane)
    expect(tag.html).to match(/^<img.*/i)
  end

end
