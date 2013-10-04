function caps(a) {return a.substring(0,1).toUpperCase() + a.substring(1,a.length);}
function uniform(a, b) { return ( (Math.random()*(b-a))+a ); }
function showSlide(id) { $(".slide").hide(); $("#"+id).show(); }
function shuffle(v) { newarray = v.slice(0);for(var j, x, i = newarray.length; i; j = parseInt(Math.random() * i), x = newarray[--i], newarray[i] = newarray[j], newarray[j] = x);return newarray;} // non-destructive.
function sum(arr) { return arr.reduce(function(a,b) {return a + b[1];}, 0); }

var nQs = 3;

$(document).ready(function() {
  showSlide("consent");
  $("#mustaccept").hide();
});

var experiment = {
  data: {},
  
  instructions: function() {
    if (turk.previewMode) {
      $("#instructions #mustaccept").show();
    } else {
      showSlide("instructions");
      $("#begin").click(function() { experiment.trial(0); })
    }
  },
  
  trial: function(qNumber) {
    $('.bar').css('width', ( (qNumber / nQs)*100 + "%"));
    showSlide("trial");
    var binNumbers = [];
    for (var i=0; i<=7; i++) {binNumbers.push(i);}
    var bins = binNumbers.map(function(i) {return $("#bin"+i);});
    var errors = binNumbers.map(function(i) {return $("#error"+i);});
    bins.map(function(bin) {bin.val("");});
    errors.map(function(error) {error.val("");});
    var totalInput;
    $("#total").html("");
    $('input').bind('input', function() {
      totalInput = 0;
      for (var i=0; i<bins.length; i++) {
        var binValue = bins[i].val();
        var error = errors[i];
        var isInt = /^[0-9]*$/.test(binValue);
        if (isInt) {
          error.html("")
          if (binValue != "") {
            totalInput += parseInt(binValue);
          }
        } else {
          error.html("invalid");
        }
      }
      $('#total').html(totalInput);
      $('#total').css("font-weight", "bold")
      if (totalInput < 1000) {
        $('#total').css("color", "black")
      } else if (totalInput == 1000) {
        $('#total').css("color", "green")
      } else {
        $('#total').css("color", "red")
      }
    });
    $("#continue").click(function() {
      function ok() {
        for (var i=0; i<bins.length; i++) {
          if (bins[i].val().length == 0) {
            return false;
          }
        }
        return true;
      }
      if (ok()) {
        if (totalInput < 1000) {
          $("#error").html("Remember, this has to add up to 1,000. You need to add " + (1000 - totalInput) + " more items.");
        } else if (totalInput > 1000) {
          $("#error").html("Remember, this has to add up to 1,000. You need to take away " + (totalInput - 1000) + " items.");
        } else {
          $("#error").html("");
          //record responses
          if (qNumber + 1 < nQs) {
            experiment.trial(qNumber+1);
          } else {
            experiment.questionaire();
          }
        }
      } else {
        $("#error").html("Please put a number for every interval. Zeros are OK.");
      }
    })
  },
  
  questionaire: function() {
    //disable return key
    $(document).keypress( function(event){
     if (event.which == '13') {
        event.preventDefault();
      }
    });
    //progress bar complete
    $('.bar').css('width', ( "100%"));
    showSlide("questionaire");
    $("#formsubmit").click(function() {
      rawResponse = $("#questionaireform").serialize();
      pieces = rawResponse.split("&");
      var age = pieces[0].split("=")[1];
      var lang = pieces[1].split("=")[1];
      var comments = pieces[2].split("=")[1];
      if (lang.length > 0) {
        experiment.data["language"] = lang;
        experiment.data["comments"] = comments;
        experiment.data["age"] = age;
        showSlide("finished");
        setTimeout(function() { turk.submit(experiment.data) }, 1000);
      }
    });
  }
}
  
