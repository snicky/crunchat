# only for textarea
# textarea's lineheight = 20
$.fn.scrollToCaret = (caretPos) ->
  newLineChars      = this.val().slice(0,caretPos).match(/\n/g)
  height            = if newLineChars then newLineChars.length * 20 else 0
  this[0].scrollTop = height