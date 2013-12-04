// Studio drop down dynamically updates based on city selection.
$(document).ready(function(){
        $("select#booking_city_id").change(function(){
            var id_value_string = $(this).val();
            if (id_value_string == "") { 
                // if the id is empty remove all the studio options from being selectable and do not do any ajax
                $("select#booking_studio_id option").remove();
                var row = "<option value=\"" + "" + "\">" + "" + "</option>";
                $(row).appendTo("select#booking_studio_id");
            }
            else {
                // Send the request and update studio dropdown 
                $.ajax({
                    dataType: "json",
                    cache: false,
                    url: '/studios/in_city_id/' + id_value_string,
                    timeout: 2000,
                    error: function(XMLHttpRequest, errorTextStatus, error){
                        alert("Failed to submit : "+ errorTextStatus+" ;"+error);
                    },
                    success: function(data){                    
                        // Clear all options from studio select 
                        $("select#booking_studio_id option").remove();
                        //put in a empty default line
                        var row = "<option value=\"" + "" + "\">" + "" + "</option>";
                        $(row).appendTo("select#booking_studio_id");                        
                        // Fill studio select 
                        $.each(data, function(i, j){
                            row = "<option value=\"" + j[0] + "\">" + j[1] + "</option>";   
                            $(row).appendTo("select#booking_studio_id");                     
                        });             
                     }
                });
            };
			});
      $("select#region").change(function(){
																var value_string = $(this).val();
																// Send the request and update studio dropdown 
																$.ajax({
																			 dataType: "json",
																			 cache: false,
																			 url: '/bookings/in_region/' + value_string,
																			 timeout: 2000,
																			 error: function(XMLHttpRequest, errorTextStatus, error){
																			 alert("Failed to submit : "+ errorTextStatus+" ;"+error);
																			 },
																			 success: function(data){                    
																			 // Clear all options from studio select 
																			 //$("select#booking_studio_id option").remove();
																			 //put in a empty default line
																			 //var row = "<option value=\"" + "" + "\">" + "" + "</option>";
																			 //$(row).appendTo("select#booking_studio_id");                        
																			 // Fill studio select 
																			 //$.each(data, function(i, j){
																			//				row = "<option value=\"" + j[0] + "\">" + j[1] + "</option>";   
																			//				$(row).appendTo("select#booking_studio_id");                     
																			//				});             
																			// }
																			 });
																};
																});
});