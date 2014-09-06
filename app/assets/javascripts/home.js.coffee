# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#
# controls
#
edit_mode_checkbox = ->
  $('#edit-mode-checkbox')

user_title = ->
  $('#user-title')

#
# queries
#
has_user_title = ->
  # TODO: what if there is no user title (no one is logged in)?
  user_title().text()?.trim().length > 0
  
is_edit_mode = ->
  # TODO: what if there is no edit mode checkbox (no one is logged in)?
  edit_mode_checkbox().prop('checked')

#
# display
#
display_data = ->
  display_user_title()

display_user_title = ->
  is_visible = has_user_title() or is_edit_mode()
  toggle(user_title(), is_visible)
  
#
# helpers
#
toggle = (element, is_visible) ->
  if is_visible
    element.removeClass('hidden')
    element.addClass('visible')
  else
    element.removeClass('visible')
    element.addClass('hidden')
    
set_edit_mode_class = (element, is_in_edit_mode) ->
  if is_in_edit_mode
    element.removeClass('view-mode')
    element.addClass('edit-mode')
  else
    element.removeClass('edit-mode')
    element.addClass('view-mode')

#
# other
#
install_handlers = ->
  edit_mode_checkbox().change ->
    user_title().attr('contentEditable', this.checked)    # TODO: move this into set_edit_mode_class?  and rename to set_edit_mode?
    set_edit_mode_class(user_title(), this.checked)
    display_data()

$(document).ready ->
  install_handlers()
  set_edit_mode_class(user_title(), this.checked)
  display_data()
