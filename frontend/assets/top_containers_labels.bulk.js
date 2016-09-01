/***************************************************************************
 * BulkActionPrintLabels - provides all the behaviour to the label printing
 * addon to the container manager
 */

/***************************************************************************
 * BulkActionPrintLabels - bulk action for printing labels
 *
 */
function BulkActionPrintLabels(bulkContainerLabels) {
  this.bulkContainerLabels = bulkContainerLabels;
  this.MENU_ID = "bulkActionPrintLabels";

  this.setup_menu_item();
}


BulkActionPrintLabels.prototype.setup_menu_item = function() {
  var self = this;

  self.$menuItem = $("#" + self.MENU_ID, self.bulkContainerLabels.$toolbar);
  self.$menuItem.on("click", function(event) {
    self.show();
  });
};


BulkActionPrintLabels.prototype.show = function() {

  var dialog_content = AS.renderTemplate("labels_bulk_action_print_labels", {
    selection: bulkContainerLabels.get_selection()
  });

  var $modal = AS.openCustomModal("bulkActionModal", this.$menuItem[0].text, dialog_content, 'full');
};

/***************************************************************************
 * Initialise the label printing as a child of the BulkContainerSearch class
 *
 */
$(function() {
 if (typeof BulkContainerSearch == 'function') {
		bulkContainerLabels = Object.create(BulkContainerSearch.prototype);
		
		bulkContainerLabels.$search_form = $('#bulk_operation_form');
		bulkContainerLabels.$results_container = $('#bulk_operation_results');
		bulkContainerLabels.$toolbar = $('.record-toolbar.bulk-operation-toolbar');
		
		new BulkActionPrintLabels(bulkContainerLabels);
		}
});
