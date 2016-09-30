//= require voltron/svg-injector

(function(){
	var svgs = document.querySelectorAll('img[data-svg="true"]');
	SVGInjector(svgs);
})();