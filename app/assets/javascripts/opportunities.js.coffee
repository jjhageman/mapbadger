disableDelete = ->
  $('#delete-options').attr('disabled', 'disabled').addClass('disabled')

enableDelete = -> 
  $('#delete-options').removeAttr('disabled').removeClass('disabled')

atLeastOneChecked = ->
  $('.delete_box:checked').length > 0

$ ->
  $('.delete_box').click -> if atLeastOneChecked() then enableDelete() else disableDelete()
