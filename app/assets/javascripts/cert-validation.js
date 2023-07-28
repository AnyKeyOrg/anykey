// Single page cert validation mod tool functions

// Elegant solution found on Stack Overflow (Q8847766)
function JSONtoCSV(data) {
  return (Object.keys(data[0]).join(",") +"\n" + data.map((d) => Object.values(d).join(",")).join("\n"));
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
    e.preventDefault(); 
    // Move button to deactive state
    
    $.ajax({
      type: 'POST',
      data: new FormData(this),
      processData: false,
      contentType: false,
      url: this.action,
      success: function(data, textStatus, jqXHR) {
        // Logging
        console.log("Ajax something good.")
        console.log(data)
        console.log(jqXHR.status)
        console.log(textStatus)

        // Put results on page
        document.getElementById('cross_check_results').innerHTML = JSONtoCSV(data.results));
        
        console.log(data.results)
            
        // Prepare CSV file from JSON
        // https://www.itsolutionstuff.com/post/how-to-export-json-to-csv-file-using-javascript-jqueryexample.html
        // https://stackoverflow.com/questions/32960857/how-to-convert-arbitrary-simple-json-to-csv-using-jq
        
        // Show and enable download button
        // Show and enable reset button
      },
      error: function(jqXHR, textStatus, errorThrown) {
        // Logging
        console.log("Ajax something bad.")
        console.log(jqXHR.responseJSON)
        console.log(jqXHR.status)
        console.log(textStatus)
        
        // Clear file upload
        // Show error message on page
      }
    });
  }); 
}

function setupDownloadCSVListener() {
  $('#download_csv').click(function(e) {
    e.preventDefault();
    var l = document.createElement("a");
    l.href = "data:text/plain;charset=UTF-8," + document.getElementById('cross_check_results').innerHTML;
    l.setAttribute("download", "results.csv");
    l.click();
  });
}

$(document).ready(function() {
  setupInputCSVListener();
  setupValidateSubmitListener();
  setupDownloadCSVListener();
});


