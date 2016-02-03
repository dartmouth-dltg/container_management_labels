$(window).on("load", function() {
	$(document).find(".label-barcode").each(function() {
		if (this.getAttribute("data")) {
		    $(this).barcode(this.getAttribute("data"), "codabar", {barHeight:30});
		}
	    });
    });
