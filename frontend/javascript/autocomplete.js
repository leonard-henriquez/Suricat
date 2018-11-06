const tagGenerator = (location) => {
  return `
    <div id="${location.id}" class="tags">${location.city}</div>
    <input type="hidden" id="hidden-${location.id}" name="importance[criteria_attributes][0][value][]" value='${JSON.stringify(location)}'>
  `
}

const scriptGenerator = (location) => {
  return `
    tag = document.getElementById('${location.id}');
    tag_input = document.getElementById('hidden-${location.id}');
    tag.addEventListener('click', (e) => {
      tag.remove();
      tag_input.remove();
    });
  `
};

const addScript = (location) => {
  var newScript = document.createElement("script");
  var inlineScript = document.createTextNode(scriptGenerator(location));
  newScript.appendChild(inlineScript);
  document.querySelector('body').appendChild(newScript);
};

const autocomplete = () => {
  document.addEventListener("DOMContentLoaded", () => {
    const input = document.getElementById('location');
    let location;

    if (input) {
      var autocomplete = new google.maps.places.Autocomplete(input, { types: [ 'geocode' ] });
      google.maps.event.addDomListener(input, 'keydown', (e) => {
        if (e.key === "Enter") {
          e.preventDefault(); // Do not submit the form on Enter.
        }
      });

      autocomplete.addListener('place_changed', () => {
        input.value = ''
        var place = autocomplete.getPlace();
        console.log(place);

        location = {
          city: place.name,
          id: place.place_id,
          lat: place.geometry.location.lat(),
          lng: place.geometry.location.lng()
        };

        input.insertAdjacentHTML('afterend', tagGenerator(location))
        addScript(location);

      });
    }
  })
}


export { autocomplete };


