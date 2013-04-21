# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $(".toggle-sidebar").click (e) ->
    e.preventDefault()
    $(".secondary-sidebar").toggleClass("open")
    $(@).toggleClass("active")
    #this is very important if you have sparkline graphs that are in a container with display:none. when the container is visible we're calling this:
    $.sparkline_display_visible()

  $(".toggle-primary-sidebar").click (e) ->
    e.preventDefault()
    $(".primary-sidebar").toggleClass("open")
    $(@).toggleClass("active")
    $.sparkline_display_visible()