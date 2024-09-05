$.validator.messages.required = "This field is empty";

var emailValidationRules = {
    rules: {},
    messages: {}
  };
  // load rule 
  $(".email_gift_value .only_number").each(function() {
    var inputId = $(this).attr("id");
    emailValidationRules.rules[inputId] = {
      required: true,
      number: true,
      min: function(element) {
        return $("#edt_MessageType").val() === "1" ? 0 : -1;
      }
    };
    emailValidationRules.messages[inputId] = {
      required: "This field is empty",
      number: "Please enter a valid number.",
      min: "Invalid value"
    };
  });
var validateModel = {
    formEmail: function(classForm) {
      var $demoForm = $(classForm);
      $demoForm.validate({
        rules: emailValidationRules.rules,
        messages: emailValidationRules.messages
      });
      return $demoForm.valid();
    }
  };
  
  $(".only_number").on("input", function () {
    let inputVal = this.value;
    inputVal = inputVal.replace(/[^\d-]/g, '');
    this.value = inputVal;
});
