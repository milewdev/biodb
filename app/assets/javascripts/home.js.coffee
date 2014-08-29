# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

display_data = (highlights) ->
  list = $('.highlights')
  for highlight in highlights
    list.append "<li>#{highlight.content}</li>"
  
$(document).ready -> 
  user_id = $('.highlights')?.data('user-id')
  $.ajax(url: "/users/#{user_id}/highlights.json").done(display_data) if user_id?
