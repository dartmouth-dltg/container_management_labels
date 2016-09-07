// Script to manage Chrome and Safari oddball behavior with sizing and page-break-after rules
// Also targets last-of-type for page-break-after: avoid rule for last label
// This is an *addition* to the container management plugin and must be migrated/checked when that plugin is updated
// See also the template file /container_management/frontend/views/top_containers/bulk_operations/_bulk_action_labels.html.erb for the code that includes this script

function labelScale() {
	// the selectors to use
	this.LABEL_SELECTOR = ".label";
	this.LABEL_SET_SELECTOR = ".labels";
	this.BARCODE_SELECTOR = "[class$=barcode]";
	this.LABEL_SCALE_SELECTOR = ".label-scaled";

	this.isChrome = navigator.userAgent.toLowerCase().indexOf("chrome") > -1;
	this.isSafari = navigator.userAgent.toLowerCase().indexOf("safari") > -1;
	this.BARCODE_HEIGHT = 30;
	
	this.barcodeType();
	this.addBrowserClasses();
	this.convertBarcodeData();
	if (autoScale) {
		this.scaleLabelFonts();
	}
}

labelScale.prototype.barcodeType = function() {
	if (typeof barcodeType == 'undefined') {
		barcodeType = "codabar";
	}
}

labelScale.prototype.addBrowserClasses = function () {
	var self = this;
	if (self.isSafari) {
		$([self.LABEL_SELECTOR, self.LABEL_SET_SELECTOR].join(",")).addClass("safari-label");
	}
	if (self.isChrome) {
		$([self.LABEL_SELECTOR, self.LABEL_SET_SELECTOR].join(",")).addClass("chrome-label");
	}
	$([self.LABEL_SELECTOR, self.LABEL_SET_SELECTOR].join(",")).last().css("page-break-after","avoid");
}

labelScale.prototype.convertBarcodeData = function() {
	// convert the barcode data attribute to real barcodes
	var self = this;
	$(document).find(self.BARCODE_SELECTOR).each(function() {
		if (this.getAttribute("data")) {
				$(this).barcode(this.getAttribute("data"), barcodeType, {barHeight:self.BARCODE_HEIGHT});
		}
	});

}
labelScale.prototype.scaleLabelFonts = function() {	
	var self = this;
	// check the size of each label to see if its overflowing and scale if necessary	
	$(self.LABEL_SELECTOR).each(function() {
		var totalHeight = $(this)[0].scrollHeight
		if ($(this).outerHeight() < totalHeight) {
			self.scale = $(this).outerHeight()/totalHeight;
			$(this).addClass(self.LABEL_SCALE_SELECTOR.replace(".",""));

			// scale the font size of all label elements
			$(self.LABEL_SCALE_SELECTOR).children("div").each( function () {
				self.LabelSetCSS($(this),"font-size");
				// FIXME: there's probably a more elegant way to do this
				// any padding is going to be an issue, so remove it
				$(this).css("padding",0);
			});
			
			// scale the barcode stripes, but not the actual text
			$(self.BARCODE_SELECTOR).children("div").each( function () {
				if (!$(this).text().length > 0) {
					self.LabelSetCSS($(this),"height");
				}
			});
		}
	});
}

// just scale the attribute
labelScale.prototype.LabelSetCSS = function(el,attr) {
	var self = this;
	$(el).css(attr, $(el).css(attr).replace("px","")*self.scale+"px");
}

$().ready( function() {
	new labelScale();
});
    
