// This file is usually in the path app/javascript/packs/application.js

import Rails from "rails-ujs";
import Turbolinks from "turbolinks";
import * as ActiveStorage from "activestorage";
import "bootstrap";
import "@fortawesome/fontawesome-free/js/all";
import "stylesheets/application.scss";
import "components";
import "bootstrap-select";
import initMap from "./gmaps";
import initCalendar from "./calendar";
import initSlider from "./slider";

require.context("../images", true);

Rails.start();
Turbolinks.start();
ActiveStorage.start();
$.fn.selectpicker.Constructor.BootstrapVersion = "4";

$(document).on("turbolinks:load", () => {
  if ($("#map").length) {
    initMap();
  }

  if ($(".simple-calendar").length) {
    initCalendar();
  }

  // if ($(".form-group").length) {
  //   initSlider();
  // }

  if ($("select").length) {
    $("select").selectpicker({
      dropupAuto: false
    });
  }
});
