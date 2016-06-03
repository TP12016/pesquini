 $(document ).ready(function ( ) {

/*
File: enterprises.js
Purpose: Provides javascript structures related to the enterprises pages.
License: GPL v3.
Pesquini Group 6
FGA - UnB Faculdade de Engenharias do Gama - University of Brasilia.
*/

  var sanctions = document.getElementsByClassName("sanction-info");
  var payments = document.getElementsByClassName("payment-info");

  var sanctions_button = document.getElementById("sanction-info-btn");
  var payments_button = document.getElementById("payment-info-btn");

  if ($(sanctions_button).hasClass("active"))
  {
    if (payments[0])
    payments[0].style.display = "none";
  }
  else
  {
    if (sanctions[0])
      sanctions[0].style.display = "none";
  }

  $(payments_button).click(function () {
    $(sanctions_button).removeClass("active");
    $(payments_button).addClass('active');

    $(sanctions).fadeOut("slow");
    $(payments).delay(500).fadeIn("slow");

  });

  $(sanctions_button).on('click', function () {
    $(payments_button).removeClass("active");
    $(sanctions_button).addClass('active');

    $(payments).fadeOut("slow");
    $(sanctions).delay(500).fadeIn("slow");
  });

});


 $(document ).ready(function ( ) {

if(document.URL.indexOf("#tf-sanction_by_state") != -1) {
  $("#tf-sanction_by_state").css("background-color","#101010");
  $("#tf-sanction_by_state").css("color","#F7F7F7");
  $("#tf-sanction_by_state").fadeOut(1);
  $("#tf-sanction_by_state").fadeIn(1500);
}

if(document.URL.indexOf("#tf-most_sanctioned_ranking") != -1) {
  $("#tf-most_sanctioned_ranking").css("background-color","#101010");
  $("#tf-most_sanctioned_ranking").css("color","#F7F7F7");
  $("#tf-most_sanctioned_ranking").fadeOut(1);
  $("#tf-most_sanctioned_ranking").fadeIn(1500);
}

if(document.URL.indexOf("#tf-sanction_by_type") != -1) {
  $("#tf-sanction_by_type").css("background-color","#101010");
  $("#tf-sanction_by_type").css("color","#F7F7F7");
  $("#tf-sanction_by_type").fadeOut(100);
  $("#tf-sanction_by_type").fadeIn(1500);
}

if(document.URL.indexOf("#tf-payment_rankings") != -1) {
  $("#tf-payment_rankings").css("background-color","#101010");
  $("#tf-payment_rankings").css("color","#F7F7F7");
  $("#tf-payment_rankings").fadeOut(1);
  $("#tf-payment_rankings").fadeIn(1500);
}

});
