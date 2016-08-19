// Script to manage Chrome and Safari oddball behavior with sizing and page-break-after rules
// Also targets last-of-type for page-break-after: avoid rule for last label
// This is an *addition* to the container management plugin and must be migrated/checked when that plugin is updated
// See also the template file /container_management/frontend/views/top_containers/bulk_operations/_bulk_action_labels.html.erb for the code that includes this script

$().ready(function() {
	var isChrome = navigator.userAgent.toLowerCase().indexOf("chrome") > -1;
	var isSafari = navigator.userAgent.toLowerCase().indexOf("safari") > -1;
	
	if (typeof barcodeType == 'undefined') {
		barcodeType = "codabar";
	}
	
	if (isSafari) {
		$(".label, .labels").addClass("safari-label");
	}
	if (isChrome) {
		$(".label, .labels").addClass("chrome-label");
	}
	$(".labels .label").last().css("page-break-after","avoid");
	
	// convert the barcode data attribute to real barcodes
	
	$(window).on("load", function() {
		$(document).find(".label-barcode").each(function() {
			if (this.getAttribute("data")) {
					$(this).barcode(this.getAttribute("data"), barcodeType, {barHeight:30});
			}
		});
	
	// check the size of each label to see if its overflowing and scale if necessary	
		$(".label").each(function() {
		//var barcodeCount = $(this).children(".label-barcode").length;
		var total = 0;
		$(this).children(".label-barcode").each(function() {total += $(this).innerHeight()});
		console.log(total);
		var totalHeight = $(this)[0].scrollHeight + total;
			if ( $(this).innerHeight() < totalHeight) {
				var scale = $(this).innerHeight()/totalHeight;
				$(this).children().css({'transform': "scale("+scale+")", 'line-height':scale });
				//$(this).css();
			}
		});
});
});
    
