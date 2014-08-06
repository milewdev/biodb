g_jobs = null
g_offset = null
g_target = null

mousedown_handler = (event) ->
  g_target = find_target_job(event, g_jobs)
  if g_target
    coords = g_target.coords
    g_offset = {x_offset: event.offsetX - coords.x, y_offset: event.offsetY - coords.y}
  
# TODO: only install this when dragging
mousemove_handler = (event) ->
  if g_target
    g_target.coords.x = event.offsetX - g_offset.x_offset
    draw_job_bars(g_jobs)
  
mouseup_handler = (event) ->
  g_target = null
  
find_target_job = (event, jobs) ->
  target_job = null
  for job in jobs
    if is_target(event, job)
      target_job = job
  target_job
      
is_target = (event, job) ->
  x = event.offsetX
  y = event.offsetY
  coords = job.coords
  (coords.x <= x) and (x <= coords.x + coords.width) and (coords.y <= y) and (y <= coords.y + coords.height)

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
  text = "#{job.company}, #{job.synopsis}, #{job.title}<br>#{job.start_date} to #{job.end_date} (#{job.duration_in_days} days)"
  $('#content').append "<p>#{text}</p>"

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
  g_jobs = jobs
  calc_job_durations(jobs)
  calc_all_job_coordinates(jobs)
  draw_job_descriptions(jobs)
  draw_job_bars(jobs)

$(document).ready -> 
  $('#drawing')[0].addEventListener('mousedown', mousedown_handler, false)
  window.addEventListener('mousemove', mousemove_handler, false)
  window.addEventListener('mouseup', mouseup_handler, false)
  $.ajax(url: '/jobs/everything.json').done(display_data)
