var avatarMenuVisible = false;

function setupAvatarOverlay() { 
  $("#editable-avatar").mouseover(function(e) {
    $("#avatar-overlay").show();
  });
  
  $("#editable-avatar").mouseout(function(e) {
    if (!avatarMenuVisible) {        
      $("#avatar-overlay").hide();
    }
  });
}

/* Show/hide dropdown menu when clicking user avatar icon */
function setupAvatarMenuToggle() {
  $("#editable-avatar").click(function() {
    if (!avatarMenuVisible) {
      avatarMenuVisible = true;
      $("#edit-avatar-container").show();
    }
    else {
      avatarMenuVisible = false;
      $("#edit-avatar-container").hide();
      $("#avatar-overlay").hide();
    }
  });
}

/* Hide dropdown menu on any click that is not the user avatar icon */
function setupAvatarMenuHide() { 
  $(document).click(function(e) {
    if(!$(e.target).closest("#editable-avatar").length && !$(e.target).closest("#edit-avatar").length) {
      if(avatarMenuVisible) {
        avatarMenuVisible = false;
        $("#edit-avatar-container").hide();
        $("#avatar-overlay").hide();
      }
    }
  });
}

function setupAvatarUploadListener() { 
  var inputs = document.querySelectorAll( '.edit-avatar-upload' );

  Array.prototype.forEach.call( inputs, function( input )
  {
  	input.addEventListener( 'change', function( e )
  	{
  		if( e.target.value )
        $("form#edit_avatar_form").submit();
  	});
  });
}

$(document).ready(function() {
  setupAvatarOverlay()
  setupAvatarMenuToggle();
  setupAvatarMenuHide();
  setupAvatarUploadListener();
});