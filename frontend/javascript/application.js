// This file is usually in the path app/javascript/packs/application.js

import "bootstrap";
import "@fortawesome/fontawesome-free/js/all";
import "stylesheets/application";
import "components";
// import "sticky-sidebar";

import Rails from "rails-ujs";
import Turbolinks from "turbolinks";
import * as ActiveStorage from "activestorage";
Rails.start();
Turbolinks.start();
ActiveStorage.start();

require.context('../images', true);

// const stickySidebar = $.fn.stickySidebar.noConflict(); // Returns $.fn.stickySidebar assigned value.
// $.fn.stickySidebar = stickySidebar; // Give $().stickySidebar functionality.
// $('#sidebar').stickySidebar({
//   topSpacing: 60,
//   bottomSpacing: 60
// });

// $('document').ready(() => {
//   const sidebar = new StickySidebar('#sidebar', {
//     containerSelector: '#content',
//     minWidth: 350
//   });
// });
