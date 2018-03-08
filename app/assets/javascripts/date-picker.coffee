datePickerSelector = ".js-date-picker"
dateTimePickerSelector = ".js-datetime-picker"
dateTimePickeInlineSelector = ".js-datetime-picker-inline"
initializedClass = "date-picker-initialized"

addEvent = ($element) ->
  $($element).on "click", ->
    $element.datetimepicker('toggle')

initInput = ($element, opts) ->
  return if $element.hasClass(initializedClass)
  $element.addClass(initializedClass)
  $element.datetimepicker(opts)
  addEvent($element) if !opts["inline"]

initInputs = (selector, opts) ->
  $(selector).each -> initInput($(this), opts)

init = ->
  initInputs(datePickerSelector, {viewMode: 'years', format: 'DD/MM/YYYY', locale: 'es'})
  initInputs(dateTimePickerSelector, sideBySide: true, format: "DD/MM/YYYY, h:mm a")
  initInputs(dateTimePickeInlineSelector, {inline: true, sideBySide: true, locale: 'es'})

$(document).on "ready turbolinks:load init-date-picker", init
