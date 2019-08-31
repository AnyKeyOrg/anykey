/*
 * Hides flash notices 
 */

window.setTimeout(function() {
    $("#notice").slideUp(500, function(){
        $(this).remove();
    });
}, 3000);