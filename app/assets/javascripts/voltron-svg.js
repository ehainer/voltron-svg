//= require svg-injector

Voltron.addModule('SVG', function(){
  return {
    initialize: function(){
      var svgs = document.querySelectorAll('img[data-svg="true"]:not(.injected-svg)');
      var options = {
        each: function(svg){
          if(svg.getAttribute && svg.getAttribute('data-size')){
            var dims = svg.getAttribute('data-size').split('x');
            svg.setAttribute('width', parseFloat(dims[0]));
            svg.setAttribute('height', parseFloat(dims[1]));
          }
        }
      };
      SVGInjector(svgs, options);
    },

    getTag: function(svg, image, options){
      options = $.extend({ src: svg, size: '16x16', svg: true, fallback: image }, options);
      if(/^[0-9]+$/.test(options['size'].toString())) options['size'] = (options['size'] + 'x' + options['size']);
      var size = options['size'].split('x');
      if(!options['width']) options['width'] = size[0];
      if(!options['height']) options['height'] = size[1];
      return $('<img />', this.getDataAttribute(options, ['size', 'svg', 'fallback']));
    },

    getDataAttribute: function(options, attributes){
      for(var i=0; i<attributes.length; i++){
        var attr = attributes[i];
        if(options[attr]){
          options['data-' + attr] = options[attr];
          delete options[attr];
        }
      }
      return options;
    }
  };
}, true);
