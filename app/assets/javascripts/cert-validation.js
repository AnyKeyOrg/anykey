// Single page cert validation mod tool functions


// Toggles the cross check button to be enabled when a CSV file has been selected
function setupInputCSVListener() { 
  var input_csv = document.getElementById('validate_certs_input_csv');
  if (input_csv)
    input_csv.addEventListener('change', function(e) {
      if (e.target.value)
        document.getElementById('validate_certs_submit').disabled = false;
      else
        document.getElementById('validate_certs_submit').disabled = true;
    });
}

// Handles cross check submit by sending input file via AJAX
function setupValidateSubmitListener() {
  $('#validate_certs_form').submit(function(e) {    
    e.preventDefault(); 
    // Move button to deactive state
    
    $.ajax({
      type: 'POST',
      data: new FormData(this),
      processData: false,
      contentType: false,
      url: this.action,
      success: function(data, textStatus, jqXHR) {
        // Put results on page
        // Show and enable download button
        // Show and enable reset button
        
        //clickedTrack.replaceWith(eval(data));
        
        console.log("Ajax something good.")
        console.log(data)
        console.log(jqXHR.status)
        console.log(textStatus)

      },
      error: function(jqXHR, textStatus, errorThrown) {
        // Clear file upload
        // Show error message on page
        
        console.log("Ajax something bad.")
        console.log(jqXHR.responseJSON)
        console.log(jqXHR.status)
        console.log(textStatus)
      }
    });
  }); 
}

$(document).ready(function() {
  setupInputCSVListener();
  setupValidateSubmitListener();
});


