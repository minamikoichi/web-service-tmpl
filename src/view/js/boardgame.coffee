getSummary = () ->

onReady = () ->
  viewModel = new BoardgameViewModel
  ko.applyBindings viewModel

$ ->
  onReady()
