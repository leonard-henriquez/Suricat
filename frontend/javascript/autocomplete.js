const tagGenerator = (place) => {
  return `
    <div class="tags">${place.name}X</div>
  `
}

function autocomplete() {
  document.addEventListener("DOMContentLoaded", function() {
    const input = document.getElementById('location');
    const inputHidden = document.getElementById('cities')

    if (input) {
      var autocomplete = new google.maps.places.Autocomplete(input, { types: [ 'geocode' ] });
      google.maps.event.addDomListener(input, 'keydown', function(e) {
        if (e.key === "Enter") {
          e.preventDefault(); // Do not submit the form on Enter.
        }
      });

      autocomplete.addListener('place_changed', function() {
        var place = autocomplete.getPlace();
        console.log(place);
        input.insertAdjacentHTML('afterend', tagGenerator(place))
        input.value = ''
        const locations = JSON.parse(inputHidden.dataset.locations)
        locations.push({
          city: place.name,
          lat: place.geometry.location.lat(),
          lng: place.geometry.location.lng()
        })
        const string = JSON.stringify(locations)
        inputHidden.dataset.locations = string
        inputHidden.value = string
      });
    }
  })
}


export { autocomplete };


