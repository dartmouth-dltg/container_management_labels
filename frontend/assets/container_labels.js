// Script to manage Chrome"s oddball behavior with page-break-after rules
// Also targets last-of-type for page-break-after: avoid rule for last label
// This is an *addition* to the container management plugin and must be migrated/checked when that plugin is updated
// See also the template file /container_management/frontend/views/top_containers/bulk_operations/_bulk_action_labels.html.erb for the code that includes this script

$(document).ready(function() {
	var isChrome = navigator.userAgent.toLowerCase().indexOf("chrome") > -1;
	
	var isSafari = navigator.userAgent.toLowerCase().indexOf("safari") > -1;
	
	if (isSafari) {
		$(".label").addClass("safari-sheet-cell");
	}
	if (isChrome) {
		$(".label").addClass("chrome-sheet-cell");
	}
	$(".labels .label").last().css("page-break-after","avoid");
});

$(window).on("load", function() {
// convert the barcode data attribute to real barcodes
	$(document).find(".label-barcode").each(function() {
		if (this.getAttribute("data")) {
		    $(this).barcode(this.getAttribute("data"), "codabar", {barHeight:30});
		}
	});
});
    
