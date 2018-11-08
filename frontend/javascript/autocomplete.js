const tagGenerator = location => `
    <div id="${location.id}" class="tags">${location.city}</div>
    <input type="hidden" id="hidden-${
      location.id
    }" name="importance[criteria_attributes][0][value][]" value='${JSON.stringify(
  location
)}'>
  `;

const scriptGenerator = location => `
    tag = document.getElementById('${location.id}');
    tag_input = document.getElementById('hidden-${location.id}');
    tag.addEventListener('click', (e) => {
      tag.remove();
      tag_input.remove();
    });
  `;

const addScript = location => {
  const newScript = document.createElement("script");
  const inlineScript = document.createTextNode(scriptGenerator(location));
  newScript.appendChild(inlineScript);
  document.querySelector("body").appendChild(newScript);
};

const autocomplete = () => {
  document.addEventListener("turbolinks:load", () => {
    const input = $("#importance__value[data-location='true']")[0];
    let location;

    if (input) {
      const autocomplete = new google.maps.places.Autocomplete(input, {
        types: ["geocode"]
      });
      google.maps.event.addDomListener(input, "keydown", e => {
        if (e.key === "Enter") {
          e.preventDefault(); // Do not submit the form on Enter.
        }
      });

      autocomplete.addListener("place_changed", () => {
        input.value = "";
        const place = autocomplete.getPlace();
        console.log(place);

        if ("place_id" in place) {
          location = {
            city: place.name,
            id: place.place_id,
            lat: place.geometry.location.lat(),
            lng: place.geometry.location.lng()
          };

          input.insertAdjacentHTML("beforebegin", tagGenerator(location));
          addScript(location);
        }
      });
    }
  });
};

export { autocomplete };
