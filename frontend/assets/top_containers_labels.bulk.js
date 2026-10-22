/***************************************************************************
 * BulkActionPrintLabels - bulk action for printing labels. Provides the
 * label printing addon to the top container bulk operations.
 */
class BulkActionPrintLabels {
  static MENU_ID = "bulkActionPrintLabels";

  constructor(bulkContainerLabels) {
    this.bulkContainerLabels = bulkContainerLabels;
    this.setupMenuItem();
  }

  setupMenuItem() {
    this.$menuItem = $("#" + BulkActionPrintLabels.MENU_ID, this.bulkContainerLabels.$toolbar);
    this.$menuItem.on("click", () => this.show());
  }

  show() {
    const dialogContent = AS.renderTemplate("labels_bulk_action_print_labels", {
      selection: this.bulkContainerLabels.get_selection(),
    });

    AS.openCustomModal("bulkActionModal", this.$menuItem.text(), dialogContent, "full");
    new PrintLabelCheckboxesSetup();
  }
}

/***************************************************************************
 * Initialise the label printing as a child of the BulkContainerSearch class
 */
$(function() {
  if (typeof BulkContainerSearch == "function") {
    const bulkContainerLabels = Object.create(BulkContainerSearch.prototype);

    bulkContainerLabels.$search_form = $("#bulk_operation_form");
    bulkContainerLabels.$results_container = $("#bulk_operation_results");
    bulkContainerLabels.$toolbar = $(".record-toolbar.bulk-operation-toolbar");

    new BulkActionPrintLabels(bulkContainerLabels);
  }
});
