// Script to manage checkbox behavior on modal dialog of label print plugin

function printLabelCheckboxesSetup() {

		// set the selectors for the checkboxes, barcode checkboxes, barcode type dropdown and the toggle all checkboxes link
		this.checkboxes = $("#print_labels_form input[type=checkbox]");
		this.barcodeCheckboxes = [$("#print_labels_form input[name=print_indicator_barcode]"),$("#print_labels_form input[name=print_location_barcode]")];
		this.barcodeTypeSelector = $("#print_labels_form select[name=barcode_type]");
		this.allCheckboxesSelector = $("#check-all-label-fields");
		
		this.barcodeActionsSetup()
		this.checkboxControl(this.checkboxes);
}

printLabelCheckboxesSetup.prototype.barcodeActionsSetup = function() {
	var self = this;
	self.barcodeCheck();
	$(self.barcodeCheckboxes).each( function() {
		$(this).click( function() {self.barcodeCheck();});
	});
}

printLabelCheckboxesSetup.prototype.checkboxControl = function(checkboxes) {
	var self = this;
	$(self.allCheckboxesSelector).click( function() {
		$(checkboxes).each( function() {
			$(this).prop("checked", true);
		});
		self.barcodeCheck();
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