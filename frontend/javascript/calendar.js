import Rails from "rails-ujs";

const setEvent = (td) => {
  const event_name = prompt();
  if (event_name === "" || event_name === null) {
    return;
  }

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
      const input = `<div class="event-calendar">${event_name}</div>`;
      td.insertAdjacentHTML("beforeend", input )
    });
};


const initCalendar = () => {
  $('.future,.today').each((i, td) => {
    $(td).click(() => {
      setEvent(td);
    });
  });
};

export { initCalendar };
