// Manages checkbox behavior on the modal dialog of the label print plugin

class PrintLabelCheckboxesSetup {
  constructor() {
    this.$form = $("#print_labels_form");
    this.$barcodeCheckboxes = this.$form.find("input[name~=barcode]");
    this.$barcodeTypeSelector = this.$form.find("select[name=barcode_type]");

    this.barcodeCheck();
    this.$barcodeCheckboxes.on("click", () => this.barcodeCheck());
  }

  // the barcode type is only relevant when a barcode field is selected
  barcodeCheck() {
    const anyChecked = this.$barcodeCheckboxes.filter(":checked").length > 0;
    this.$barcodeTypeSelector.prop("disabled", !anyChecked);
  }
}

$(function() {
  new PrintLabelCheckboxesSetup();
});
