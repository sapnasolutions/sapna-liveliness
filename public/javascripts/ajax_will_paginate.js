// This is to implement AJAX Pagination
document.observe("dom:loaded", function() {
  // the element in which we will observe all clicks and capture
  // ones originating from pagination links
  var container = $(document.body)

  if (container) {
    var img = new Image
    img.src = '/images/indicators/small.gif'

    function createSpinner(id) {
      return new Element('img', { src: img.src, 'class': 'spinner left', 'align' : 'middle', 'id' : id })
    }

    function get_parent_id(element){
      if(element.up().id == ""){
        if(element.up().up().id == ""){
          return element.up().up().up.id;
        }else{
          return element.up().up().id;
        }
      }else{
        return element.up().id;
      }
    }

    container.observe('click', function(e) {
      var el = e.element()
      if(el.match('.pagination a')) {
        var spinner_id = "pagination_spinner" + get_parent_id(el)
        if($(spinner_id) == null){
          el.up('.pagination').insert(createSpinner(spinner_id))
        }else{
          $(spinner_id).show();
        }
        new Ajax.Request(el.href, { method: 'get' })
        e.stop()
      }
    })
  }
})
/* Ajax pagination ends here */