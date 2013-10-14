// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require turbolinks
//= require_tree .

jQuery(document).ready(function() {
  $("#notification").hide();
  var source = new EventSource('/projects/1/builds/1'),
      message;
  source.addEventListener('build.data', function (e) {
    message = JSON.parse(e.data);
    if(message.name == "status" && message.content == "completed"){
      window.location.reload(); 
    }
    else {
     $("#form").hide(1000);
     $("#notification").show(1000);
     $("#messages").append($('<li>').text(message.name + ': ' + message.content));
    }
  });
});
