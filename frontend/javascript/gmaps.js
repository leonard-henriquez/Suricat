import GMaps from "gmaps/gmaps";
import blue from "../images/map-marker-blue.svg";
import red from "../images/map-marker-red.svg";
import { autocomplete } from './autocomplete';

autocomplete();

let map;
let markers;

const setZoom = () => {
  if (map === undefined || markers === undefined) {
    return;
  }

  if (markers.length === 0) {
    map.setZoom(2);
  } else if (markers.length === 1) {
    map.setZoom(5);
    map.setCenter({ lat: markers[0].lat, lng: markers[0].lng });
  } else {
    map.fitLatLngBounds(markers);
  }
};

const onResize = () => {
  if ($("#map").length) {
    $("#map").css({ width: "100%", height: "50%" });
    google.maps.event.trigger(map, "resize");
    setZoom();
  }
};

const initMap = () => {
  const mapElement = document.getElementById("map");
  if (mapElement) {
    map = new GMaps({
      el: "#map",
      disableDefaultUI: true,
      lat: 0,
      lng: 0
    });

    const iconBlue = {
      // Adresse de l'icône personnalisée
      url: blue,
      // Taille de l'icône personnalisée
      size: new google.maps.Size(32, 40),
      // Origine de l'image, souvent (0, 0)
      origin: new google.maps.Point(0, 0),
      // L'ancre de l'image. Correspond au point de l'image que l'on raccroche à la carte. Par exemple, si votre îcone est un drapeau, cela correspond à son mâts
      anchor: new google.maps.Point(16, 40)
    };

    const iconRed = {
      url: red,
      size: new google.maps.Size(32, 40),
      origin: new google.maps.Point(0, 0),
      anchor: new google.maps.Point(16, 40)
    };

    markers = [];
    let marker;
    if (
      mapElement.dataset.pending !== undefined &&
      mapElement.dataset.applied !== undefined
    ) {
      const markersPending = JSON.parse(mapElement.dataset.pending);
      const markersApplied = JSON.parse(mapElement.dataset.applied);

      markersPending.forEach(marker => {
        marker.icon = iconBlue;
        map.addMarker(marker);
        markers.push(marker);
      });

      markersApplied.forEach(marker => {
        marker.icon = iconRed;
        map.addMarker(marker);
        markers.push(marker);
      });

      markers.forEach(marker => {
        markers.push(marker);
      });
    } else if (mapElement.dataset.marker !== undefined) {
      marker = JSON.parse(mapElement.dataset.marker);
      marker.icon = iconRed;
      map.addMarker(marker);
      markers.push(marker);
    }

    $(window).resize(onResize);
    setTimeout(setZoom, 0);
  }
};

export default initMap;
