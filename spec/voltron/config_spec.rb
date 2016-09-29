require "rails_helper"

describe Voltron::Config do
  
  it "yields instance of Voltron::Config::Svg" do
  	expect(Voltron.config.svg).to be_a(Voltron::Config::Svg)
  end

  it "should be buildable" do
  	expect(Voltron.config.svg.buildable?).to eq(true)

  	Voltron.config.svg.build_environment = :development

  	expect(Voltron.config.svg.buildable?).to eq(false)
  end

end
