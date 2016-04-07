$(document).on("ready page:load",function(){

  if($('#use_billing').attr('checked') == 'checked') {
    $('#shipping_form').hide();
  } else {
    $('#shipping_form').show();
  }

  $("#use_billing:checkbox").change(function(){
    if(this.checked){
      $('#shipping_form').hide(300);
      $('#use_billing').val('1');
    } else{
      $('#shipping_form').show(200);
      $('#use_billing').val('0');
    }
  });
});