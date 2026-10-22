// Manages Chrome and Safari oddball behavior with sizing and page-break-after rules
// Also targets last-of-type for page-break-after: avoid rule for last label
// Converts barcode data attributes to barcodes and optionally scales overflowing labels
// See frontend/views/labels/_bulk_action_labels.html.erb for the code that includes this script

class LabelScale {
  static LABEL_SELECTOR = ".label";
  static LABEL_SET_SELECTOR = ".labels";
  static BARCODE_SELECTOR = "[class$=barcode]";
  static LABEL_SCALE_CLASS = "label-scaled";
  static BARCODE_HEIGHT = 30;

  constructor({ barcodeType = "codabar", autoScale = false } = {}) {
    this.barcodeType = barcodeType || "codabar";
    this.autoScale = autoScale;

    // chrome's user agent also contains "safari", so exclude it
    const ua = navigator.userAgent.toLowerCase();
    this.isChrome = ua.includes("chrome");
    this.isSafari = ua.includes("safari") && !this.isChrome;

    this.addBrowserClasses();
    this.convertBarcodeData();
    if (this.autoScale) {
      this.scaleLabelFonts();
    }
  }

  addBrowserClasses() {
    const $labels = $([LabelScale.LABEL_SELECTOR, LabelScale.LABEL_SET_SELECTOR].join(","));

    if (this.isSafari) {
      $labels.addClass("safari-label");
    }
    if (this.isChrome) {
      $labels.addClass("chrome-label");
    }
    $labels.last().css("page-break-after", "avoid");
  }

  // convert the barcode data attribute to real barcodes
  convertBarcodeData() {
    $(document).find(LabelScale.BARCODE_SELECTOR).each((i, el) => {
      const data = el.getAttribute("data");
      if (data) {
        $(el).barcode(data, this.barcodeType, { barHeight: LabelScale.BARCODE_HEIGHT });
      }
    });
  }

  // check the size of each label to see if it is overflowing and scale if necessary
  scaleLabelFonts() {
    $(LabelScale.LABEL_SELECTOR).each((i, label) => {
      const $label = $(label);
      const totalHeight = label.scrollHeight;

      if ($label.outerHeight() >= totalHeight) {
        return;
      }

      const scale = $label.outerHeight() / totalHeight;
      $label.addClass(LabelScale.LABEL_SCALE_CLASS);

      // scale the font size of all label elements
      $label.children("div").each((j, el) => {
        this.scaleCSS($(el), "font-size", scale);
        // any padding is going to be an issue, so remove it
        $(el).css("padding", 0);
      });

      // scale the barcode stripes, but not the actual text
      $label.find(LabelScale.BARCODE_SELECTOR).children("div").each((j, el) => {
        if ($(el).text().length === 0) {
          this.scaleCSS($(el), "height", scale);
        }
      });
    });
  }

  // just scale the attribute
  scaleCSS($el, attr, scale) {
    $el.css(attr, parseFloat($el.css(attr)) * scale + "px");
  }
}
