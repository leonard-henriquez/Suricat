// This file is usually in the path app/javascript/packs/application.js

require.context('../images', true);
import "bootstrap";
import "@fortawesome/fontawesome-free/js/all";
import "stylesheets/application";
import "components";
import "gmaps";



import Rails from "rails-ujs";
import Turbolinks from "turbolinks";
import * as ActiveStorage from "activestorage";
Rails.start();
Turbolinks.start();
ActiveStorage.start();
