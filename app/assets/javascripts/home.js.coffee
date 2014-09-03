# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

textarea_keydown = (event) ->
  if event.which == 13      # enter (TODO: use a constant)
    
    # insert new li
    existing_textarea = $(event.target)
    existing_parent_ul = existing_textarea.parent().get(0)
    new_textarea = $("<textarea data-id='-1'></textarea>")
    new_li = $("<li></li>")
    new_li.append(new_textarea)
    new_li.insertAfter(existing_parent_ul)
    
    # move everything after the current cursor position to the new textarea
    # TODO: need to handle case when the user has selected some text
    new_textarea_text = existing_textarea.range(existing_textarea.caret()).range().text
    new_textarea.val(new_textarea_text)
    existing_textarea.range(existing_textarea.caret()).range('')

    # TODO: trim spaces from end of existing_textarea after split?  But then do we
    # add a space when we join via the delete key?

    # position the cursor
    new_textarea.focus()

    # eat the return
    return false 
    
  if event.which == 8       # backspace (TODO: use a constant)
    current_textarea = $(event.target)
    if current_textarea.caret() == 0    # at start of line
      prev_li = current_textarea.parent().prev()[0]
      if not $.isEmptyObject(prev_li)   # not on the first highlight
        prev_li = $(prev_li)
        prev_textarea = prev_li.children().first()
        new_caret_position = prev_textarea.val().length
        prev_textarea.val( prev_textarea.val() + current_textarea.val() )
        current_textarea.parent().remove()
        prev_textarea.focus()
        prev_textarea.caret(new_caret_position)
        return false

display_data = (highlights) ->
  list = $('.highlights')
  for highlight in highlights
    list.append "<li><textarea data-id='#{highlight.id}'>#{highlight.content}</textarea></li>"
  
$(document).ready -> 
  $('ul.highlights').on('keydown', 'textarea', textarea_keydown)
  user_id = $('.highlights')?.data('user-id')
  $.ajax(url: "/users/#{user_id}/highlights.json").done(display_data) if user_id?
