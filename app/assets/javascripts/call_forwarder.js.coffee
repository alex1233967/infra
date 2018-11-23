jQuery ->
        $("#messageBox").hide().slideDown();
        setTimeout ( ->
          $("#messageBox").slideUp();
        ), 3000
