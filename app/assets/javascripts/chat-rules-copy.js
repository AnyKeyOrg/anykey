/*
 * Programs button to copy
 * chat rules to clipboard
 */

function setupCopyChatRulesListener() {
 $("#copy-link").click(function() {
   
   var rulesText = document.getElementById("rules-text");
   
   rulesText.style.display = "inherit";

    if (navigator.userAgent.match(/ipad|iphone/i)) {
      var input = document.querySelector("#rules-text");
      var editable = input.contentEditable;
      var readOnly = input.readOnly;

      input.contentEditable = true;
      input.readOnly = false;

      var range = document.createRange();
      range.selectNodeContents(input);

      var selection = window.getSelection();
      selection.removeAllRanges();
      selection.addRange(range);

      input.setSelectionRange(0, 999999);
      input.contentEditable = editable;
      input.readOnly = readOnly;
    } else {
      document.querySelector("#rules-text").select();
    }
    
    document.execCommand('copy');
    rulesText.style.display = "none";
  
  });
};

$(document).ready(function() {
  setupCopyChatRulesListener();
});