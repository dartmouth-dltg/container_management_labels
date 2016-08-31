// Script to manage checkbox behavior on modal dialog of label print plugin

function printLabelCheckboxesSetup() {

		// set the selectors for the checkboxes, barcode checkboxes, barcode type dropdown and the toggle all checkboxes link
		this.formName = "#print_labels_form";
		this.checkboxes = $("#print_labels_form input[type=checkbox]");
		this.barcodeCheckboxes = "#print_labels_form input[name~=barcode]";
		this.barcodeTypeSelector = $("#print_labels_form select[name=barcode_type]");
		
		this.barcodeActionsSetup()
}

printLabelCheckboxesSetup.prototype.barcodeActionsSetup = function() {
	var self = this;
	self.barcodeCheck();
	$(self.barcodeCheckboxes).each( function() {
		$(this).click( function() {self.barcodeCheck();});
	});
}

printLabelCheckboxesSetup.prototype.barcodeCheck = function() {
	var self = this;
	$(self.barcodeCheckboxes).each( function() {
		if ($(this).prop("checked")) {
		 self.barcodeControl(true); 
		 return false;
		}
		else self.barcodeControl(false);
	});
}
	
printLabelCheckboxesSetup.prototype.barcodeControl = function(control) {
	var self = this;
	if (!control) {
			self.barcodeTypeSelector.prop("disabled", true);
		}
	else self.barcodeTypeSelector.prop("disabled", false);
}

$().ready( function() {
	new printLabelCheckboxesSetup();
});