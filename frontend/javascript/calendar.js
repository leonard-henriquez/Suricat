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
        body: JSON.stringify({ query: event.currentTarget.date })
      })
        .then(response => response.json())
        .then((data) => {
          console.log(data.event_name); // Look at local_names.default

        });


    });
  });
});
