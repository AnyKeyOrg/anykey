// Single page cert validation mod tool functions

// Converts JSON to plain CSV text
// Adapts Ruby rake task to JS
// Thanks to solution on Stack Overflow (Q8847766)
function JSONtoCSV(data) {
  var keys = []
  data.map((d) => keys.push(Object.keys(d)))
  var headers = new Set(keys.flat(1))
  return (Array.from(headers).join(",") +"\n" + data.map((d) => Object.values(d).join(",")).join("\n"));
}

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
    
    // Intercept click and release button from focus state
    e.preventDefault();
    $('#validate_certs_submit').blur();

    $.ajax({
      type: 'POST',
      data: new FormData(this),
      processData: false,
      contentType: false,
      url: this.action,
      success: function(data, textStatus, jqXHR) {
        // Hide cross check button
        $('#validate_certs_submit').hide();
        
        // Hide instructions
        $('#cross_check_instructions').hide();
        
        // Update subheading
        document.getElementById('cross_check_subheading').innerHTML = "Results"
        
        // Convert JSON response to CSV and show results on page
        document.getElementById('cross_check_results').innerHTML = JSONtoCSV(data.results);
        
        // Show download and reset buttons
        $("#download_csv_button").show();
        $('#reset_validation_button').show();
      },
      error: function(jqXHR, textStatus, errorThrown) {
        // Show reset button
        $('#reset_validation_button').show();
        
        // Hide instructions
        $('#cross_check_instructions').hide();
        
        // Update subheading
        document.getElementById('cross_check_subheading').innerHTML = "Results"
        
        // Show error message on page
        var statusMessage = ""
        if (jqXHR.responseJSON)
          statusMessage = jqXHR.responseJSON.error;
        else
          statusMessage = jqXHR.status;
        document.getElementById('cross_check_results').innerHTML = textStatus.toUpperCase() + ": " + statusMessage;
      }
    });
  }); 
}

// Generates downloadable CSV file from the JSON data dumped onto page
// Thanks to another tip from Stack Overflow (Q609530)
function setupDownloadCSVListener() {
  $('#download_csv_button').click(function(e) {
    e.preventDefault();
    var l = document.createElement("a");
    l.href = "data:text/csv;charset=UTF-8," + encodeURIComponent(document.getElementById('cross_check_results').innerHTML);
    l.setAttribute("download", "results.csv");
    l.click();
  });
}

$(document).ready(function() {
  setupInputCSVListener();
  setupValidateSubmitListener();
  setupDownloadCSVListener();
});
