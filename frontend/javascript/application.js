// This file is usually in the path app/javascript/packs/application.js

import "bootstrap";
import "stylesheets/application";

import Rails from 'rails-ujs';
import Turbolinks from 'turbolinks';
import * as ActiveStorage from 'activestorage';
Rails.start();
Turbolinks.start();
ActiveStorage.start();
