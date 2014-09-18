# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


#
# variables
#

dirty_flag = false


#
# controls
#

edit_mode_checkbox = ->
  $('#edit-mode-checkbox')
  
save_button = ->
  $('#save-button')
  
user_name = ->
  $('#user-name')

user_title = ->
  $('#user-title')
  
user_email = ->
  $('#user-email')
  
user_highlights = ->
  $('#user-highlights')


#
# queries
#

is_resume_page = ->
  user_title().length > 0
  
is_edit_mode = ->
  # TODO: what if there is no edit mode checkbox (no one is logged in)?
  edit_mode_checkbox().prop('checked')

is_dirty = ->
  dirty_flag
  
# TODO: trimming will be implemented on the server, but when should we do it on the client?  After saving?
is_field_populated = (element) ->
  element.text()?.trim().length > 0

  
#
# backend
#

save_data = ->
  user_patch = {}
  user_patch.name = user_name().text()              # TODO: does this need to be HTML, SQL, etc. escaped?
  user_patch.title = user_title().text()            # TODO: does this need to be HTML, SQL, etc. escaped?
  user_patch.highlights = user_highlights().text()  # TODO: does this need to be HTML, SQL, etc. escaped?
  $.ajax({
    url: "/users/#{user_title().data('user-id')}.json",
    type: 'PUT',
    dataType: 'json',
    data: { _method: 'PATCH', user: user_patch }
  }).done(
    (data, textStatus, jqXHR) ->
      # TODO: need to check for errors returned by server
      set_dirty(false)
  # ).fail(
  #   ( jqXHR, textStatus, errorThrown ) ->
  #     console.log "ajax fail: jqXHR.responseText='#{jqXHR.reponseText}', textStatus='#{textStatus}', errorThrown='#{errorThrown}'"
  )


#
# helpers
#

set_field_visibility = (element, is_visible) ->
  if is_visible
    element.removeClass('hidden').addClass('visible')
  else
    element.removeClass('visible').addClass('hidden')
    
set_fields_to_edit_mode = (is_in_edit_mode) ->
  set_field_to_edit_mode(user_name(), is_in_edit_mode)
  set_field_to_edit_mode(user_title(), is_in_edit_mode)
  set_field_to_edit_mode(user_email(), false)           # always 'false' because email is not editable
  set_field_to_edit_mode(user_highlights(), is_in_edit_mode)

set_field_to_edit_mode = (element, is_in_edit_mode) ->
  element.attr('contentEditable', is_in_edit_mode)
  if is_in_edit_mode
    element.removeClass('view-mode').addClass('edit-mode')
  else
    element.removeClass('edit-mode').addClass('view-mode')

display_data = ->
  display_field(user_name())
  display_field(user_title())
  display_field(user_email())
  display_field(user_highlights())
  
display_field = (element) ->
  is_visible = is_field_populated(element) or is_edit_mode()
  set_field_visibility(element, is_visible)

enable_save_button = (enabled) ->
  save_button().prop('disabled', not enabled)

set_dirty = (dirty)->
  dirty_flag = dirty
  enable_save_button(dirty)


#
# other
#

install_handlers = ->
  
  edit_mode_checkbox().change ->
    set_fields_to_edit_mode(this.checked)
    display_data()
    save_data() if is_dirty()                             # TODO: move the 'if is_dirty()' guard into save_data()
    
  save_button().click ->
    save_data()
    
  user_name().on 'input', ->
    set_dirty(true)
    
  user_title().on 'input', ->                             # TODO: this will need to be applied to any editable page element
    set_dirty(true)
    
  user_highlights().on 'input', ->
    set_dirty(true)
    
  window.onbeforeunload = ->
    return 'Data you have entered may not be saved.' if is_dirty()
    return undefined                                      # 'undefined' suppresses 'leave page?' prompt

ready = ->
  if is_resume_page()
    install_handlers()
    set_fields_to_edit_mode(false)
    set_dirty(false)
    display_data()

$(document).ready(ready)
