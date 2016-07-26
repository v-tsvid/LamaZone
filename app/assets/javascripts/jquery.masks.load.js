$(document).on("ready page:load",function(){
  var phone_mask = "+99 999 999 9999";
  $("#order_model_billing_address_phone").mask(phone_mask);
  $("#order_model_shipping_address_phone").mask(phone_mask);
  $(".phone").mask(phone_mask);
});