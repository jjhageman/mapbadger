Mapbadger.Utility = {
  formatNumber: (number) ->
    number.toString().replace /\B(?=(\d{3})+(?!\d))/g, ","
}
