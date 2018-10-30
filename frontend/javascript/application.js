// This file is usually in the path app/javascript/packs/application.js

import "bootstrap";
import "@fortawesome/fontawesome-free/js/all";
import "stylesheets/application";
import "components";

import Rails from "rails-ujs";
import Turbolinks from "turbolinks";
import * as ActiveStorage from "activestorage";
Rails.start();
Turbolinks.start();
ActiveStorage.start();

require.context('../images', true);
