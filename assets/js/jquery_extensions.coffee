# only for textarea
# textarea's lineheight = 20
$.fn.scrollToCaret = (caretPos) ->
  newLineChars      = this.val().slice(0,caretPos).match(/\n/g)
  height            = if newLineChars then newLineChars.length * 20 else 0
  this[0].scrollTop = height

$(window).focus ->
  $.windowHasFocus = true

$(window).blur ->
  $.windowHasFocus = false

$(window).load ->
  # cant find workaround to assign $.windowHasFocus at the load time
  $.windowHasFocus = document.hasFocus() if document.hasFocus
  $.windowHasFocus ||= true