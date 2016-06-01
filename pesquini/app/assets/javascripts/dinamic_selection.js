 $(document ).ready(function ( ) {

/*
File: dinamic_selection.js
Purpose: Script for dynamic selection in the application.
License: GPL v3.
Pesquini Group 6
FGA - UnB Faculdade de Engenharias do Gama - University of Brasilia.
*/

    var select_button = document.getElementById('select_button');
    if (select_button)
    {
      select_button.style.display = "none";
    }

    $('#select_tag').change(function() {
    $(this).closest('form').trigger('submit');
    });

});
