milliseconds_to_days = (milliseconds) ->
  ((((milliseconds  / 1000) / 60) / 60) / 24)
  
calc_job_durations = (jobs) ->
  calc_job_duration(job) for job in jobs
  
calc_job_duration = (job) ->
  # start_date = new Date(job.start_date)
  # end_date = new Date(job.end_date)
  # duration_in_milliseconds = end_date.getTime() - start_date.getTime()
  # job.duration_in_days = milliseconds_to_days(duration_in_milliseconds)
  # TODO: implement this
  job.duration_in_days = 100
    
calc_all_job_coordinates = (jobs) ->
  calc_job_coordinates(job, i) for job, i in jobs

calc_job_coordinates = (job, i) ->
  # x = milliseconds_to_days((new Date(job.start_date)).getTime() - (new Date(2010,1,1)).getTime()) / 10
  # width = milliseconds_to_days((new Date(job.end_date)).getTime() - (new Date(job.start_date)).getTime()) / 10
  # TODO: implement this
  x = 10
  width = 50
  y = 10 + (10 * i)
  job.coords = {x: x, y: y, width: width, height: 6}
    
draw_job_descriptions = (jobs) ->
  draw_job_description(jobs, job) for job in jobs
  draw_job_description(jobs, {})                        # TODO: rethink how to add blank row
  
draw_job_description = (jobs, job) ->                   # TODO: need to use a class to avoid passing 'jobs' around
  row = $('<tr></tr>')
  row.data('job', job)
  $('#editor').append(row)
  for field_name in ['company', 'title', 'when']
    do (field_name) ->                                  # ensure field_name is not shared among the field closures
      td = $('<td></td>')
      row.append(td)
      value = job[field_name] or ""
      input = $("<input type='text' value='#{value}'></input>")
      input.on('input', (event) -> input_key_press(jobs, job, field_name, event) )
      td.append(input)

input_key_press = (jobs, job, field_name, event) ->     # TODO: need to use a class to avoid passing 'jobs' around
  value = $(event.target).val()
  job[field_name] = value                               # update internal data structure
  job_patch = {}
  job_patch[field_name] = value
  if job.id                                             # existing job
    $.ajax(                                             # update server
      url: job.url,
      type: 'PATCH',
      data: { job: job_patch }
    )
    display_graph(jobs)                                 # update display (use observer pattern? overkill perhaps)
  else
    $.ajax(
      url: '/jobs.json',                                # TODO: can we get this from somewhere, e.g. job.url
      type: 'POST',
      data: { job: job_patch }
    ).done( (added_job_data) ->                         # TODO: this will not work; need to wait until we get response before submitting updates
      job.id = added_job_data.id 
      job.url = added_job_data.url
      jobs.push(job)
      display_graph(jobs)                               # update display (use observer pattern? overkill perhaps)
    )
  check_new_row(jobs, event)
  
check_new_row = (jobs, event) ->
  row = get_row(event)
  if is_last_row(row)
    add_blank_row(jobs) unless is_row_empty(row)
  else if is_second_last_row(row) 
    if is_row_empty(row)
      job = row.data('job')
      if job.id
        delete_job(job)
        delete job.id
        delete job.url
        index = $.inArray(job, jobs)
        jobs.splice(index, 1) unless index == -1
        display_graph(jobs)                             # update display (use observer pattern? overkill perhaps)
      remove_last_row()
      
delete_job = (job) ->
  $.ajax(
    url: job.url,
    type: 'DELETE'
  )
    
get_row = (event) ->
  input = $(event.target)
  td = input.parent()
  tr = td.parent()
  tr
  
is_last_row = (tr) ->
  table = tr.parent()
  tr_last = $(table.find('tr:last'))
  same = tr_last.is(tr)
  same
  
is_second_last_row = (tr) ->
  table = tr.parent()
  tr_second_last = $(table.find('tr:last').prev())
  same = tr_second_last.is(tr)
  same
  
is_row_empty = (tr) ->
  for input in tr.find('input')
    if $(input).val().trim().length > 0
      return false
  return true
  
add_blank_row = (jobs) ->
  draw_job_description(jobs, {})                        # TODO: rethink how to add blank row
  
remove_last_row = ->
  $('#editor tr:last').remove()
  
draw_job_bars = (jobs) ->
  canvas = $('#drawing')[0]
  context = canvas.getContext('2d')
  clear_drawing(canvas, context)
  draw_job_bar(context, job) for job in jobs
  
draw_job_bar = (context, job) ->
  coords = job.coords
  context.fillStyle = '#00f'
  context.fillRect( coords.x, coords.y, coords.width, coords.height)
  
clear_drawing = (canvas, context) ->
  context.save()
  context.clearRect(0,0,canvas.width,canvas.height)
  context.restore()
  
display_data = (jobs) ->
  draw_job_descriptions(jobs)
  display_graph(jobs)
  
display_graph = (jobs) ->
  calc_job_durations(jobs)
  calc_all_job_coordinates(jobs)
  draw_job_bars(jobs)
  
$(document).ready -> 
  $.ajax(url: '/jobs/everything.json').done(display_data)
