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
  $('tbody#editor').append(
    "<tr data-job-id='#{job.id}'>" +
      "<td><input type='text' id='company' value='#{job.company}'></input></td>" +
      "<td><input type='text' id='title' value='#{job.title}'></input></td>" +
      "<td><input type='text' id='start_date' value='#{job.start_date}'></input></td>" +
      "<td><input type='text' id='end_date' value='#{job.end_date}'></input></td>" +
    "</tr>"
  )

input_key_press = (event) ->
  tr = $(event.target).parent().parent()
  job_id = tr.data('job-id')
  company = tr.find('input#company').val()
  title = tr.find('input#title').val()
  start_date = tr.find('input#start_date').val()
  end_date = tr.find('input#end_date').val()
  # alert "#{job_id}, #{company}, #{title}, #{start_date}, #{end_date}"
  $.ajax(
    url: "/jobs/#{job_id}.json",
    type: 'PATCH',
    data: { job: { company: company, title: title, start_date: start_date, end_date: end_date } }
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
  
bind_handlers = ->
  $(document).on('input', 'tbody#editor input[type="text"]', input_key_press )

$(document).ready -> 
  bind_handlers()
  $.ajax(url: '/jobs/everything.json').done(display_data)
