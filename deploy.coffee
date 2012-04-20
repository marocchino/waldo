control = require 'control'
task    = control.task
perform = control.perform

task 'production', 'Config for production server', ->
  config =
    'svn.filepang.co.kr':
      user: 'marocchino'
      #sshOptions: ['-t', '-t']
  control.controllers(config)

#coffee deploy.coffee production date
task 'date', 'Get date', (controller) ->
  controller.ssh 'date'

task 'log', 'Get logs', (controller) ->
  controller.ssh 'cat ~/projects/waldo/logs/waldo.log'

task 'deploy', 'deploy the latest version of the app', (controller) ->
  controller.ssh 'cd ~/projects/waldo/ && git pull origin master', ->
    perform 'restart', controller

task 'update_dependencies', 'upgrade socketstream', (controller) ->
  controller.ssh 'cd downloads/socketstream/ && git pull origin master && npm link', ->

task 'restart', 'restart the application', (controller) ->
  controller.ssh 'cd ~/projects/waldo/ && /etc/init.d/waldo restart'

task 'stop', 'stop the application', (controller) ->
  controller.ssh 'cd ~/projects/waldo/ && /etc/init.d/waldo stop'

task 'start', 'stop the application', (controller) ->
  controller.ssh 'cd ~/projects/waldo/ && /etc/init.d/waldo start'

control.begin()
