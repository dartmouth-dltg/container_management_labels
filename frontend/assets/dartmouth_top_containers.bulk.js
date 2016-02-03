/***************************************************************************
 * BulkActionPrintLabels - provides all the behaviour to the label printing
 * addon to the container manager
 */

/***************************************************************************
 * BulkActionPrintLabels - bulk action for printing labels
 *
 */
function BulkActionPrintLabels(dartmouth_bulkContainerLabels) {
  this.dartmouth_bulkContainerLabels = dartmouth_bulkContainerLabels;
  this.MENU_ID = "bulkActionPrintLabels";

  this.setup_menu_item();
}


BulkActionPrintLabels.prototype.setup_menu_item = function() {
  var self = this;

  self.$menuItem = $("#" + self.MENU_ID, self.dartmouth_bulkContainerLabels.$toolbar);
  self.$menuItem.on("click", function(event) {
    self.show();
  });
};


BulkActionPrintLabels.prototype.show = function() {

  var dialog_content = AS.renderTemplate("dartmouth_bulk_action_print_labels", {
    selection: dartmouth_bulkContainerLabels.get_selection()
  });

  var $modal = AS.openCustomModal("bulkActionModal", this.$menuItem[0].text, dialog_content, 'full');
};

/***************************************************************************
 * Initialise the label printing as a child of the BulkContainerSearch class
 *
 */
$(function() {
 if (typeof BulkContainerSearch == 'function') {
		dartmouth_bulkContainerLabels = Object.create(BulkContainerSearch.prototype);
		
		dartmouth_bulkContainerLabels.$search_form = $('#bulk-operation-form');
		dartmouth_bulkContainerLabels.$results_container = $('#bulk-operation-results');
		dartmouth_bulkContainerLabels.$toolbar = $('.record-toolbar.bulk-operation-toolbar');
		
		new BulkActionPrintLabels(dartmouth_bulkContainerLabels);
		}
});
