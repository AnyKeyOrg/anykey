// Listens for Twitch username on badge activation form
// Shows status on form and loads Twitch ID if found

function setupActivationTwitchListeners() {
  $("#activate_badge_twitch_username").on("keyup", function(e) {
    if (!this.value) {
      $("#activate_badge_twitch_username_status").attr("class","status-response"); // Reset status of empty field
      $("#activate_badge_twitch_id").val('');
      $("#activate_badge_twitch_id").hide();
      $("#activate_badge_submit").prop("disabled", true);
    }
    else {
      $("#activate_badge_twitch_username_status").attr("class","status-response searching"); // Set status to searching
      if (this.value.match(/^([A-Za-z0-9_]{4,25})$/)) { // Only lookup ID if input is valid Twitch username (4-25 alphanumeric incl. underscore)
        $.ajax({
          type: 'GET',
          data: { twitch_username: this.value },
          url: $(this).data("url"),
          success: function(data, textStatus, jqXHR) {
            $("#activate_badge_twitch_username_status").attr("class","status-response found");  // Set status to found
            $("#activate_badge_twitch_id").val(data.twitch_id);
            $("#activate_badge_twitch_id").show();
            $("#activate_badge_submit").prop("disabled", false);
          },
          error: function(jqXHR, textStatus, errorThrown) {
            $("#activate_badge_twitch_username_status").attr("class","status-response not-found"); // Set status to not found
            $("#activate_badge_twitch_id").val('');
            $("#activate_badge_twitch_id").hide();
            $("#activate_badge_submit").prop("disabled", true);
          }
        });
      }
      else {
        $("#activate_badge_twitch_username_status").attr("class","status-response invalid"); // Set status to invalid
        $("#activate_badge_twitch_id").val('');
        $("#activate_badge_twitch_id").hide();
        $("#activate_badge_submit").prop("disabled", true);
      }
    }
  });
}

$(document).ready(function() {
  setupActivationTwitchListeners();
});
