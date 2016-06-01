/*
File: show.js
Purpose: Provides javascript structures for sanction.
License: GPL v3.
Pesquini Group 6
FGA - UnB Faculdade de Engenharias do Gama - University of Brasilia.
*/

  var sanctions_btn = document.getElementById("sanction-info-btn");

if ($(sanctions_btn).hasClass("active"))
{
  $(".sanction-info").html("<%= escape_javascript(render("sanctions")) %>");
}
else
{
  $(".payment-info").html("<%= escape_javascript(render("payments")) %>");
}