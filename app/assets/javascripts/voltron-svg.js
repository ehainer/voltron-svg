//= require voltron/svg-injector

if(Voltron){
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
        options = $.extend(options, { src: svg, size: '16x16', svg: true, fallback: image });
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
}else{
  (function(funcName, baseObj) {
    "use strict";
    // The public function name defaults to window.docReady
    // but you can modify the last line of this function to pass in a different object or method name
    // if you want to put them in a different namespace and those will be used instead of 
    // window.docReady(...)
    funcName = funcName || "docReady";
    baseObj = baseObj || window;
    var readyList = [];
    var readyFired = false;
    var readyEventHandlersInstalled = false;
    
    // call this when the document is ready
    // this function protects itself against being called more than once
    function ready() {
      if (!readyFired) {
        // this must be set to true before we start calling callbacks
        readyFired = true;
        for (var i = 0; i < readyList.length; i++) {
          // if a callback here happens to add new ready handlers,
          // the docReady() function will see that it already fired
          // and will schedule the callback to run right after
          // this event loop finishes so all handlers will still execute
          // in order and no new ones will be added to the readyList
          // while we are processing the list
          readyList[i].fn.call(window, readyList[i].ctx);
        }
        // allow any closures held by these functions to free
        readyList = [];
      }
    }
    
    function readyStateChange() {
      if ( document.readyState === "complete" ) {
        ready();
      }
    }
    
    // This is the one public interface
    // docReady(fn, context);
    // the context argument is optional - if present, it will be passed
    // as an argument to the callback
    baseObj[funcName] = function(callback, context) {
      // if ready has already fired, then just schedule the callback
      // to fire asynchronously, but right away
      if (readyFired) {
        setTimeout(function() {callback(context);}, 1);
        return;
      } else {
        // add the function and context to the list
        readyList.push({fn: callback, ctx: context});
      }
      // if document already ready to go, schedule the ready function to run
      // IE only safe when readyState is "complete", others safe when readyState is "interactive"
      if (document.readyState === "complete" || (!document.attachEvent && document.readyState === "interactive")) {
        setTimeout(ready, 1);
      } else if (!readyEventHandlersInstalled) {
        // otherwise if we don't have event handlers installed, install them
        if (document.addEventListener) {
          // first choice is DOMContentLoaded event
          document.addEventListener("DOMContentLoaded", ready, false);
          // backup is window load event
          window.addEventListener("load", ready, false);
        } else {
          // must be IE
          document.attachEvent("onreadystatechange", readyStateChange);
          window.attachEvent("onload", ready);
        }
        readyEventHandlersInstalled = true;
      }
    }
  })("docReady", window);

  window.injectSVG = function(){
    var svgs = document.querySelectorAll('img[data-svg="true"]');
    var options = {
      each: function(svg){
        if(svg.getAttribute('data-size')){
          var dims = svg.getAttribute('data-size').split('x');
          svg.setAttribute('width', parseFloat(dims[0]));
          svg.setAttribute('height', parseFloat(dims[1]));
        }
      }
    };
    SVGInjector(svgs, options);
  };

  docReady(injectSVG);
}
