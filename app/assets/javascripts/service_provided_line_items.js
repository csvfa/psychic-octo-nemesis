function update_amount() {
  document.getElementById("service_provided_line_item_amount").value = document.getElementById("service_provided_line_item_rate_per_person").value * document.getElementById("service_provided_line_item_no_people").value;
  document.getElementById("service_provided_line_item_amount").disabled = false
}