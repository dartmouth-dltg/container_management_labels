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
 * Add label printing to core's bulk container operations. Core calls
 * AS.initBulkContainerOperations on the Top Containers page and each time the
 * Manage Top Containers modal opens on a resource or accession, so hook in there
 * rather than at page load (the modal's toolbar does not exist yet then).
 */
(function() {
  if (typeof BulkContainerSearch !== "function" || typeof AS.initBulkContainerOperations !== "function") {
    return;
  }

  const initBulkContainerOperations = AS.initBulkContainerOperations;

  AS.initBulkContainerOperations = function($form, $results, $toolbar) {
    initBulkContainerOperations.apply(this, arguments);

    const bulkContainerLabels = Object.create(BulkContainerSearch.prototype);
    bulkContainerLabels.$search_form = $form;
    bulkContainerLabels.$results_container = $results;
    bulkContainerLabels.$toolbar = $toolbar;

    new BulkActionPrintLabels(bulkContainerLabels);
  };
})();
