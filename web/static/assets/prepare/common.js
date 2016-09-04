(function() {
  var FALLBACK = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsQAAA7EAZUrDhsAAAANSURBVBhXYzh8+PB/AAffA0nNPuCLAAAAAElFTkSuQmCC';

  window.Antenna = window.Antenna || {};
  window.Antenna.betterChoice = function(img, thumbs) {
    var cnt = 0;
    var thumb = thumbs[cnt] || {}

    img.src = thumb.src;
    img.onerror = function() {
      // TODO: request notifierd fallback img to own img removal api.

      if (thumbs.length < cnt) {
        this.src = FALLBACK;
        this.onerror = null;
        return;
      }

      cnt++
      this.src = (thumbs[cnt] || {}).src;
    }
  };

  /* Common function */

  // Speed up calls to hasOwnProperty
  var hasOwnProperty = Object.prototype.hasOwnProperty;

  window.Antenna.isEmpty = function (obj) {

      // null and undefined are "empty"
      if (obj == null) return true;

      // Assume if it has a length property with a non-zero value
      // that that property is correct.
      if (obj.length > 0)    return false;
      if (obj.length === 0)  return true;

      // If it isn't an object at this point
      // it is empty, but it can't be anything *but* empty
      // Is it empty?  Depends on your application.
      if (typeof obj !== "object") return true;

      // Otherwise, does it have any properties of its own?
      // Note that this doesn't handle
      // toString and valueOf enumeration bugs in IE < 9
      for (var key in obj) {
          if (hasOwnProperty.call(obj, key)) return false;
      }

      return true;
  };

})();
