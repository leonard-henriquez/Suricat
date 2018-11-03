import Rails from "rails-ujs";

var simpleCalendarTdEvent = null;

const createEvent = (eventName) => {
  const td = simpleCalendarTdEvent;
  const date = $(td).data("date");

  fetch("/events", {
    method: "POST",
    headers: {
      'Content-Type': 'application/json',
      'X-CSRF-Token': Rails.csrfToken()
    },
    credentials: 'same-origin',
    body: JSON.stringify({ event: { start_time: date, name: eventName } })
  })
    .then(response => response.json())
    .then((data) => {
      const input = `<div class="event-calendar">${eventName}</div>`;
      td.insertAdjacentHTML("beforeend", input )
    });
};

const callEventCreator = () => {
  let eventName = null;
  if ($('#event-name-modal').length) {
    eventName = $('#event-name').val();
    $('#event-name-modal').modal('hide');
  } else {
    eventName = prompt('Please enter an event name');
  }

  if (eventName === "" || eventName === null) {
    return;
  }

  createEvent(eventName);
};

const askEventName = (td) => {
  simpleCalendarTdEvent = td;
  if ($('#event-name-modal').length) {
    $('#event-name').val('');
    $('#event-name-modal').modal('show');
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

  if ($('#event-name-modal').length) {
    $(document).keypress(function(e) {
      if ($("#event-name-modal").hasClass('show') && (e.keycode == 13 || e.which == 13)) {
        e.preventDefault();
        callEventCreator();
      }
    });

    $('#submit-new-event').click((e) => {
      e.preventDefault();
      callEventCreator();
    });

    $('#event-name-modal').on('shown.bs.modal', () => {
      $('#event-name').trigger('focus');
    });
  }
};

export { initCalendar };
