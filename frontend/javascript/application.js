// This file is usually in the path app/javascript/packs/application.js

import Rails from "rails-ujs";
import Turbolinks from "turbolinks";
import * as ActiveStorage from "activestorage";
import "bootstrap";
import "@fortawesome/fontawesome-free/js/all";
import "stylesheets/application.scss";
import "components";
import "bootstrap-select";
import List from "list.js";
import initMap from "./gmaps";
import initCalendar from "./calendar";
import autocomplete from "./autocomplete";
import { loadTags } from "./tags";
import introductionTutorial from "./intro";

require.context("../images", true);

Rails.start();
Turbolinks.start();
ActiveStorage.start();
$.fn.selectpicker.Constructor.BootstrapVersion = "4";

if (typeof SuricatGlobalObject === "undefined") {
  const SuricatGlobalObject = {};
}

$(document).on("turbolinks:load", () => {
  if ($("#map").length) {
    initMap();
  }

  if ($(".simple-calendar").length) {
    initCalendar();
  }

  if ($("select").length) {
    $("select").selectpicker({
      dropupAuto: false
    });
  }

  if ($(".jobcard").length) {
    List("job-cards", {
      valueNames: ["jobcard-title", "jobcard-date", "jobcard-auto-grade"]
    });
  }

  if (
    typeof SuricatGlobalObject.tags !== "undefined" &&
    SuricatGlobalObject.tags &&
    $("#importance__value[data-location='true']").length
  ) {
    const input = $("#importance__value[data-location='true']")[0];
    loadTags(SuricatGlobalObject.tags, input, "city");
    autocomplete(input);
  }

  if (typeof SuricatGlobalObject.intro !== "undefined" && SuricatGlobalObject.intro) {
    introductionTutorial();
    SuricatGlobalObject.intro = false;
  }
});
