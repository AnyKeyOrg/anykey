// Listens for Twitch usernames on badge abuse report form
// Shows status on form and sets Twitch IDs if found
// Very handy, but should be DRYer since it repeats 3x

function setupReportTwitchListeners() {
  $("#report_reported_twitch_name").on("blur", function(e) {
    if (this.value.length == 0) {
      $("#reported_twitch_name_status").attr("class","status-response flexbox vertical end"); // Reset status of empty field
      $("#report_reported_twitch_id").val('');
    }
    else {
      $("#reported_twitch_name_status").attr("class","status-response searching flexbox vertical end"); // Set status to searching
      if (this.value.match(/^([A-Za-z0-9_]{4,25})$/)) { // Only lookup ID if input is valid Twitch username (4-25 alphanumeric incl. underscore)
        $.ajax({
          type: 'GET',
          data: { twitch_username: this.value },
          url: $(this).data("url"),
          success: function(data, textStatus, jqXHR) {
            $("#reported_twitch_name_status").attr("class","status-response found flexbox vertical end");  // Set status to found
            $("#report_reported_twitch_id").val(data.twitch_id);
          },
          error: function(jqXHR, textStatus, errorThrown) {
            $("#reported_twitch_name_status").attr("class","status-response not-found flexbox vertical end"); // Set status to not found
            $("#report_reported_twitch_id").val('');
          }
        });
      }
      else
        $("#reported_twitch_name_status").attr("class","status-response invalid flexbox vertical end"); // Set status to invalid
        $("#report_reported_twitch_id").val('');
    }
  });
  
  $("#report_reporter_twitch_name").on("blur", function(e) {
    if (this.value.length == 0) {
      $("#reporter_twitch_name_status").attr("class","status-response flexbox vertical end"); // Reset status of empty field
      $("#report_reporter_twitch_id").val('');
    }
    else {
      $("#reporter_twitch_name_status").attr("class","status-response searching flexbox vertical end"); // Set status to searching
      if (this.value.match(/^([A-Za-z0-9_]{4,25})$/)) { // Only lookup ID if input is valid Twitch username (4-25 alphanumeric incl. underscore)
        $.ajax({
          type: 'GET',
          data: { twitch_username: this.value },
          url: $(this).data("url"),
          success: function(data, textStatus, jqXHR) {
            $("#reporter_twitch_name_status").attr("class","status-response found flexbox vertical end");  // Set status to found
            $("#report_reporter_twitch_id").val(data.twitch_id);
          },
          error: function(jqXHR, textStatus, errorThrown) {
            $("#reporter_twitch_name_status").attr("class","status-response not-found flexbox vertical end"); // Set status to not found
            $("#report_reporter_twitch_id").val('');
          }
        });
      }
      else
        $("#reporter_twitch_name_status").attr("class","status-response invalid flexbox vertical end"); // Set status to invalid
        $("#report_reporter_twitch_id").val('');
    }
  });
  
  $("#report_incident_stream").on("blur", function(e) {
    if (this.value.length == 0) {
      $("#incident_stream_status").attr("class","status-response flexbox vertical end"); // Reset status of empty field
      $("#report_incident_stream_twitch_id").val('');
    }
    else {
      $("#incident_stream_status").attr("class","status-response searching flexbox vertical end"); // Set status to searching
      if (this.value.match(/^([A-Za-z0-9_]{4,25})$/)) { // Only lookup ID if input is valid Twitch username (4-25 alphanumeric incl. underscore)
        $.ajax({
          type: 'GET',
          data: { twitch_username: this.value },
          url: $(this).data("url"),
          success: function(data, textStatus, jqXHR) {
            $("#incident_stream_status").attr("class","status-response found flexbox vertical end");  // Set status to found
            $("#report_incident_stream_twitch_id").val(data.twitch_id);
          },
          error: function(jqXHR, textStatus, errorThrown) {
            $("#incident_stream_status").attr("class","status-response not-found flexbox vertical end"); // Set status to not found
            $("#report_incident_stream_twitch_id").val('');
          }
        });
      }
      else
        $("#incident_stream_status").attr("class","status-response invalid flexbox vertical end"); // Set status to invalid
        $("#report_incident_stream_twitch_id").val('');
    }
  });
}

$(document).ready(function() {
  setupReportTwitchListeners();
});
