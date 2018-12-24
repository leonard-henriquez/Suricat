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
import introJs from "intro.js";
import initMap from "./gmaps";
import initCalendar from "./calendar";
import autocomplete from "./autocomplete";
import test from "./tags";

require.context("../images", true);

Rails.start();
Turbolinks.start();
ActiveStorage.start();
$.fn.selectpicker.Constructor.BootstrapVersion = "4";

const importancesValues = {};

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

  if (typeof intro !== 'undefined' && intro) {
    introJs()
      .setOption("overlayOpacity", 0)
      .setOption("hidePrev", true)
      .setOption("hideNext", true)
      .setOption("highlightClass", "bg-transparent")
      .start();
    intro = false;
  }

  test();
});
