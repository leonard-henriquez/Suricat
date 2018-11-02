import Rails from "rails-ujs";

const createEvent = (td, event_name) => {
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

const callEventCreator = (td) => {
  let event_name = null;
  if ($('#eventNameModal').length) {
    event_name = $('#event_name').val();
    $('#eventNameModal').modal('hide');
  } else {
    event_name = prompt();
  }

  if (event_name === "" || event_name === null) {
    return;
  }

  createEvent(td, event_name);
};

const askEventName = (td) => {
  if ($('#eventNameModal').length) {
    $('#event_name').val('');
    $('#eventNameModal').modal('show');
    $('#submit-new-event').click(() => {
      callEventCreator(td);
    });
  } else {
    callEventCreator(td);
  }
};

const initCalendar = () => {
  $('.future,.today').each((i, td) => {
    $(td).click(() => {
      askEventName(td);
    });
  });

  if ($('#eventNameModal').length) {
    $('#eventNameModal').on('shown.bs.modal', () => {
      $('#event_name').trigger('focus');
    });
  }
};

export { initCalendar };
