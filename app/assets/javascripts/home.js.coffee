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


#
# queries
#

has_user_name = ->
  # TODO: what if there is no user name because no one is logged in?
  # TODO: trimming will be implemented on the server, but when should we do it on the client?  After saving?
  user_name().text()?.trim().length > 0
  
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
  display_user_name()
  display_user_title()
  
display_user_name = ->
  is_visible = has_user_name() or is_edit_mode()
  toggle(user_name(), is_visible)

display_user_title = ->
  is_visible = has_user_title() or is_edit_mode()
  toggle(user_title(), is_visible)
  
  
#
# backend
#

save_data = ->
  user_patch = {}
  user_patch.name = user_name().text()      # TODO: does this need to be HTML, SQL, etc. escaped?
  user_patch.title = user_title().text()    # TODO: does this need to be HTML, SQL, etc. escaped?
  $.ajax(
    url: "/users/#{user_title().data('user-id')}.json",
    type: 'PUT',
    dataType: 'json',
    data: { _method: 'PATCH', user: user_patch }
  ).done(
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
    
is_resume_page = ->
  user_title().length > 0
  
enable_save_button = (enabled) ->
  save_button().prop('disabled', not enabled)

set_dirty = (dirty)->
  dirty_flag = dirty
  enable_save_button(dirty)
  
is_dirty = ->
  dirty_flag


#
# other
#

install_handlers = ->
  
  edit_mode_checkbox().change ->
    user_name().attr('contentEditable', this.checked)     # TODO: move this into set_edit_mode_class?  and rename to set_edit_mode?
    user_title().attr('contentEditable', this.checked)
    set_edit_mode_class(user_name(), this.checked)
    set_edit_mode_class(user_title(), this.checked)
    display_data()
    save_data() if is_dirty()
    
  save_button().click ->
    save_data()
    
  user_name().on 'input', ->
    set_dirty(true)
    
  user_title().on 'input', ->                             # TODO: this will need to be applied to any editable page element
    set_dirty(true)
    
  window.onbeforeunload = ->
    return 'Data you have entered may not be saved.' if is_dirty()
    return undefined                                      # 'undefined' suppresses 'leave page?' prompt
    
ready = ->
  if is_resume_page()
    install_handlers()
    set_edit_mode_class(user_name(), edit_mode_checkbox().checked)  # TODO: smells; why do we need to know about edit_mode_checkbox?
    set_edit_mode_class(user_title(), edit_mode_checkbox().checked)
    set_edit_mode_class(user_email(), false)              # always 'false' because email is not editable
    set_dirty(false)
    display_data()

$(document).ready(ready)
