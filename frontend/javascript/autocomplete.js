import { addTag } from "./tags";

const autocomplete = input => {
  if (!input) {
    return;
  }

  let location;

  const autocompleteObject = new google.maps.places.Autocomplete(input, {
    types: ["geocode"]
  });
  google.maps.event.addDomListener(input, "keydown", e => {
    if (e.key === "Enter") {
      e.preventDefault(); // Do not submit the form on Enter.
    }
  });

  autocompleteObject.addListener("place_changed", () => {
    input.value = "";
    const place = autocompleteObject.getPlace();
    console.log(place);

    if ("place_id" in place) {
      location = {
        city: place.name,
        id: place.place_id,
        lat: place.geometry.location.lat(),
        lng: place.geometry.location.lng()
      };

      addTag(input, location, "city");
    }
  });
};

export default autocomplete;
