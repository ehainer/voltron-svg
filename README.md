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

To implement the built in svg injector, include the following in `application.js`

```
//= require voltron-svg
```

The built in svg injector utilizes Iconic's [SVGInjector](https://github.com/iconic/SVGInjector) library. Refer to the github page for documentation, but note that Voltron SVG does not currently provide a way to alter the config, as it's designed to work with the markup that is output by Voltron SVG by default. See below for example:

```html
<img width="150" height="150" alt="anchor" data-svg="true" data-size="150x150" data-fallback="/assets/anchor.150x150.TEAL-8cf90f05009ceff4967786502d3c840ef14a79dcb40fa84b156c8ec94e35dfeb.png" src="/assets/anchor.TEAL-f982442b37f0c6c919e15d015d1d0ed9e8c4647116ae4a849ce48b9f7e315c13.svg">
```

If however you desire more control over the SVG injection process, feel free to not include the `//= require voltron-svg` in application.js, and then roll your own implementation. All tags output by Voltron SVG will follow the same format as the above markup, so you should have access to everything you'd need to do... whatever.

## Usage

The following assumes the presence of the file `phone.svg` in the `Voltron.config.svg.source_directory` path.

Voltron SVG adds the method `svg_tag` to the view helpers, so in your views you can display an SVG with an identical PNG as a fallback image simple by writing:

```erb
<div class="contact">
  <%= svg_tag :phone %>
  <span>Call This Number</span>
</div>
```

Or specify some options to customize the output:

```erb
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

All other options will be passed to the internal `image_tag` call, so you may also provide options like `:alt`, `:class`, or `:data` and it will be present on the generated <img /> tag. Note that Voltron SVG adds it's own `data-*` attributes (data-svg, data-size, data-fallback to be exact), but they will be merged with any data hash you provide when calling svg_tag. So basically, the 'size', 'svg', and 'fallback' data-* attributes are reserved, but any other data param is fair game.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ehainer/voltron-svg. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

