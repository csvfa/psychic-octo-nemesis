function update_bookings_div(o){var e=document.getElementById(o).checked;jQuery.ajax({url:"/set_filtered_regions",type:"GET",data:{region:o,add:e},dataType:"html",success:function(o){jQuery("#bookingsDiv").html(o)}})}$(document).ready(function(){$("select#booking_city_id").change(function(){var o=$(this).val();if(""==o){$("select#booking_studio_id option").remove();var e='<option value=""></option>';$(e).appendTo("select#booking_studio_id")}else $.ajax({dataType:"json",cache:!1,url:"/studios/in_city_id/"+o,timeout:2e3,error:function(o,e,i){alert("Failed to submit : "+e+" ;"+i)},success:function(o){$("select#booking_studio_id option").remove();var e='<option value=""></option>';$(e).appendTo("select#booking_studio_id"),$.each(o,function(o,i){e='<option value="'+i[0]+'">'+i[1]+"</option>",$(e).appendTo("select#booking_studio_id")})}})})});