datePickerSelector = ".js-date-picker"
dateTimePickerSelector = ".js-datetime-picker"
initializedClass = "date-picker-initialized"

initInput = ($element, opts) ->
  return if $element.hasClass(initializedClass)
  $element.addClass(initializedClass)
  $element.datepicker(opts)

initInputs = (selector, opts) ->
  $(selector).each -> initInput($(this), opts)

init = ->
  initInputs(datePickerSelector, viewMode: 'years', format: "DD/MM/YYYY")
  initInputs(dateTimePickerSelector, sideBySide: true, format: "DD/MM/YYYY, h:mm a")

$(document).on "ready page:load init-date-picker", init
