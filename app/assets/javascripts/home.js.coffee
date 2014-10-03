# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


#
# constants
#

HIGHLIGHT_NAME_CLASS = 'highlight-name'
HIGHLIGHT_CONTENT_CLASS = 'highlight-content'


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
  
user_jobs = ->
  $('#user-jobs')


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
is_populated = (element) ->
  element.text()?.trim().length > 0

  
#
# backend
#

save_data = ->
  user_patch = {
    name: user_name().text(),                 # TODO: does this need to be HTML, SQL, etc. escaped?
    title: user_title().text(),               # TODO: does this need to be HTML, SQL, etc. escaped?
    highlights: highlights_view_to_model(),   # TODO: does this need to be HTML, SQL, etc. escaped?
    jobs: jobs_view_to_model()                # TODO: does this need to be HTML, SQL, etc. escaped?
  }
  $.ajax({
    url: "/users/#{user.id}.json",
    type: 'PUT',
    dataType: 'json',
    data: { _method: 'PATCH', user: user_patch }
  }).done(
    (data, textStatus, jqXHR) ->
      # TODO: need to check for errors returned by server
      set_dirty(false)
      # TODO: temporary logging for debugging
      # console.log "ajax done: jqXHR.responseText='#{jqXHR.reponseText}', textStatus='#{textStatus}'"
  ).fail(
    ( jqXHR, textStatus, errorThrown ) ->
      # TODO: temporary logging for debugging
      console.log "ajax fail: jqXHR.responseText='#{jqXHR.reponseText}', textStatus='#{textStatus}', errorThrown='#{errorThrown}'"
  )


#
# helpers
#

set_dirty = (dirty)->
  dirty_flag = dirty
  enable_save_button(dirty)
    
enable_save_button = (enabled) ->
  save_button().prop('disabled', not enabled)

set_fields_to_edit_mode = (is_in_edit_mode) ->
  set_field_to_edit_mode(user_name(), is_in_edit_mode)
  set_field_to_edit_mode(user_title(), is_in_edit_mode)
  set_field_to_edit_mode(user_email(), false)           # always 'false' because email is not editable
  set_field_to_edit_mode($('.highlight-name, .highlight-content'), is_in_edit_mode)
  set_field_to_edit_mode($('.company, .date-range, .role, .tasks'), is_in_edit_mode)

set_field_to_edit_mode = (element, is_in_edit_mode) ->
  element.attr('contentEditable', is_in_edit_mode)
  if is_in_edit_mode
    element.removeClass('view-mode').addClass('edit-mode')
  else
    element.removeClass('edit-mode').addClass('view-mode')
    
populate_data = ->
  populate_field(user_name(), user.name)
  populate_field(user_title(), user.title)
  populate_field(user_email(), user.email)
  populate_field(user_highlights(), highlights_model_to_view(user.highlights))
  populate_field(user_jobs(), jobs_model_to_view(user.jobs))

populate_field = (element, source)->
  element.html(source)

display_data = ->
  display_field(user_name())
  display_field(user_title())
  display_field(user_email())
  display_field(user_highlights())
  display_field(user_jobs())
  
display_field = (element) ->
  is_visible = is_populated(element) or is_edit_mode()
  set_field_visibility(element, is_visible)

set_field_visibility = (element, is_visible) ->
  if is_visible
    element.removeClass('hidden').addClass('visible')
  else
    element.removeClass('visible').addClass('hidden')
  

#
# view models?
#

# model_value = [ { name: 'languages', content: 'C, C++' }, ... ]
highlights_model_to_view = (highlights) ->
  highlights = [{name:'', content:''}] if highlights.length == 0        # always want at least one row
  ( build_highlight_row(highlight) for highlight in highlights ).join()
  
build_highlight_row = (highlight) ->
  "<tr>" +
  "<td class='#{HIGHLIGHT_NAME_CLASS}'>#{highlight.name}</td>" +
  "<td class='#{HIGHLIGHT_CONTENT_CLASS}'>#{highlight.content}</td>" +
  "</tr>"

highlights_view_to_model = ->
  # TODO: clean this up
  highlights = []
  user_highlights().find('tr').each ->
    name = $($(this).children()[0]).text()
    content = $($(this).children()[1]).text()
    highlights.push( {name:name, content:content} )
  JSON.stringify(highlights)
  
jobs_model_to_view = (jobs) ->
  jobs = [{company:'', date_range: '', role: '', tasks: []}] if jobs.length == 0    # always want at least one row
  ( build_job_row(job) for job in jobs ).join('')

build_job_row = (job) ->
  "<tr>" +
  "<td class='left-column'><p class='company'>#{job.company}</p><p class='date-range'>#{job.date_range}</p><p class='role'>#{job.role}</p></td>" +
  "<td class='right-column'>#{tasks_model_to_view(job.tasks)}</td>" +
  "</tr>"
  
tasks_model_to_view = (tasks) ->
  tasks = [''] if tasks.length == 0   # always want at least one row
  "<ul class='tasks'>" + ( build_task_row(task) for task in tasks ).join('') + "</ul>"
  
build_task_row = (task) ->
  "<li>#{task}</li>"
  
jobs_view_to_model = ->
  # TODO: clean this up
  jobs = []
  user_jobs().find('tr').each ->
    company = $($(this).find('.company')).text()
    date_range = $($(this).find('.date-range')).text()
    role = $($(this).find('.role')).text()
    tasks = tasks_view_to_model( $($(this).find('.tasks li')) )
    jobs.push( {company:company, date_range:date_range, role:role, tasks:tasks} )
  JSON.stringify(jobs)
  
tasks_view_to_model = (view_list) ->
  tasks = []
  view_list.each ->
    tasks.push($(this).text())
  tasks


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
    
  user_highlights().on 'input', ->                        # TODO: use a class selector instead, e.g. $('.edit-mode')
    set_dirty(true)
    
  user_jobs().on 'input', ->                              # TODO: use a class selector instead, e.g. $('.edit-mode')
    set_dirty(true)
    
  $('#user-highlights').on 'keypress', ".#{HIGHLIGHT_NAME_CLASS}", (event) ->
    return true unless event.which == 13
    $(this).next().focus()
    return false

  $('#user-highlights').on 'keypress', ".#{HIGHLIGHT_CONTENT_CLASS}", (event) ->
    return true unless event.which == 13
    current_row = $(this).closest('tr')
    new_row = current_row.clone(true)
    new_row.find('td').text('')
    current_row.after(new_row)
    new_row.find('td:first').focus()
    return false

  window.onbeforeunload = ->
    return 'Data you have entered may not be saved.' if is_dirty()
    return undefined                                      # 'undefined' suppresses 'leave page?' prompt


ready = ->
  if is_resume_page()
    install_handlers()
    populate_data()
    set_fields_to_edit_mode(false)
    set_dirty(false)
    display_data()

$(document).ready(ready)
