[![Build Status](https://travis-ci.org/ehainer/voltron-svg.svg?branch=master)](https://travis-ci.org/ehainer/voltron-svg)

# Voltron::Svg

For lazy people who just want to work with SVG icons and have fallback images created for them.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'voltron-svg'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install voltron-svg

Then run the following to create the voltron.rb initializer (if not exists already) and add the svg config:

    $ rails g voltron:svg:install

## Usage

The following assumes the presence of the file `phone.svg` in the `Voltron.config.svg.source_directory` path.

Voltron SVG adds the method `svg_tag` to the view helpers, so in your views you can display an SVG with an identical PNG as a fallback image simple by writing:

```ruby
<div class="contact">
  <%= svg_tag :phone %>
  <span>Call This Number</span>
</div>
```

Or specify some options to customize the output:

```ruby
<div class="contact">
  <%= svg_tag :phone, color: :teal, size: "50x50", quality: 100 %>
  <span>Call This Number</span>
</div>
```

Or use in SASS by writing:

```sass
.contact {
  width: 50px;
  height: 50px;
  background-image: svg-icon(phone, $color: teal, $quality: 100, $size: "50x50");
  background-repeat: no-repeat;
}
```

If a color is specified, Voltron SVG will create a duplicate SVG file of the icon you want to display, and replace the color of all fills and paths with the color you defined. Any color format that would be valid in CSS is valid for the value of the color option, including, but not limited to: `#323A45`, `rebeccapurple`, or `rgba(100, 100, 100, 0.7)`

For reasons that may or may not be obvious, only the entire color of the SVG can be specified. Multi-color SVG's will receive a "color flood" if a color is provided, because sadly I don't have a way to write code for "make this line this color, but this area this color, and that line another color..." given an abstract SVG file that can have any number of path's and areas to color.

## Options

Possible options for `svg_tag` and `svg-icon`

* :color -> The color, silly
* :quality -> The generated PNG quality. Default: 90
* :width -> The width, duh
* :height -> The height, duh
* :size -> Use is same as in `image_tag`, could be specified as "50x50" or just "50" (this option takes priority if :width and :height are also provided)
* :fallback -> If you don't want it to use the default generated fallback image, provide a specific image name, i.e. - "my-more-awesome-fallback.png"
* :extension -> Likely not needed, but if you call `svg_tag :phone` but for some reason it doesn't have a *.svg extension, you can call `svg_tag :phone, extension: "flub"` to have it find "phone.flub" instead. Or just write `svg_tag "phone.flub"` in the first place.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ehainer/voltron-svg. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

