milliseconds_to_days = (milliseconds) ->
  ((((milliseconds  / 1000) / 60) / 60) / 24)
  
calc_job_durations = (jobs) ->
  calc_job_duration(job) for job in jobs
  
calc_job_duration = (job) ->
  start_date = new Date(job.start_date)
  end_date = new Date(job.end_date)
  duration_in_milliseconds = end_date.getTime() - start_date.getTime()
  job.duration_in_days = milliseconds_to_days(duration_in_milliseconds)
    
calc_all_job_coordinates = (jobs) ->
  calc_job_coordinates(job, i) for job, i in jobs

calc_job_coordinates = (job, i) ->
  x = milliseconds_to_days((new Date(job.start_date)).getTime() - (new Date(2010,1,1)).getTime()) / 10
  y = 10 + (20 * i)
  job.coords = {x: x, y: y, width: 100, height: 10}
    
draw_job_descriptions = (jobs) ->
  draw_job_description(job) for job in jobs
  
draw_job_description = (job) ->
  tr = $('<tr></tr>')
  $('tbody#editor').append(tr)
  for field_name in ['company', 'title', 'start_date', 'end_date']
    do (field_name) ->        # ensure field_name is not shared among the field closures
      td = $('<td></td>')
      tr.append(td)
      input = $("<input type='text' id='#{field_name}' value='#{job[field_name]}'></input>")
      input.on('input', (event) -> input_key_press(job, field_name, event) )
      td.append(input)

input_key_press = (job, field_name, event) ->
  value = $(event.target).val()
  job_patch = {}
  job_patch[field_name] = value
  $.ajax(
    url: job.url,
    type: 'PATCH',
    data: { job: job_patch }
  )
  
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
  calc_job_durations(jobs)
  calc_all_job_coordinates(jobs)
  draw_job_descriptions(jobs)
  draw_job_bars(jobs)
  
$(document).ready -> 
  $.ajax(url: '/jobs/everything.json').done(display_data)
