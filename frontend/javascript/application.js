// This file is usually in the path app/javascript/packs/application.js

require.context('../images', true);
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

$(document).ready(() => {
  $('.future,.today').each((i, td) => {
    $(td).click(() => {
      const event_name = prompt();
      const date = $(td).data("date");

      fetch("/events", {
        method: "POST",
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': Rails.csrfToken()
        },
        credentials: 'same-origin',
        body: JSON.stringify({ event: { start_time: date, name: event_name } })
      })
        .then(response => response.json())
        .then((data) => {
          console.log(data); // Look at local_names.default
          // TODO Ajouter l'event en js dans le HTML
          const input = `<div class="event-calendar">${event_name}</div>`;
          td.insertAdjacentHTML("beforeend", input )
        });


    });
  });
});
