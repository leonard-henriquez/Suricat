import GMaps from "gmaps/gmaps";
import blue from "../images/map-marker-blue.svg";
import red from "../images/map-marker-red.svg";

const initMap = () => {
  const mapElement = document.getElementById("map");
  if (mapElement) {
    const map = new GMaps({ el: "#map", lat: 0, lng: 0 });
    const markers = [];
    if (JSON.parse(mapElement.dataset.pending)) {
      const markersPending = JSON.parse(mapElement.dataset.pending);
      const markersApplied = JSON.parse(mapElement.dataset.applied);

      const iconPending = {
        // Adresse de l'icône personnalisée
        url: blue,
        // Taille de l'icône personnalisée
        size: new google.maps.Size(32, 40),
        // Origine de l'image, souvent (0, 0)
        origin: new google.maps.Point(0, 0),
        // L'ancre de l'image. Correspond au point de l'image que l'on raccroche à la carte. Par exemple, si votre îcone est un drapeau, cela correspond à son mâts
        anchor: new google.maps.Point(16, 40)
      };

      const iconApplied = {
        url: red,
        size: new google.maps.Size(32, 40),
        origin: new google.maps.Point(0, 0),
        anchor: new google.maps.Point(16, 40)
      };

      markersPending.forEach(marker => {
        marker.icon = iconPending;
        map.addMarker(marker);
      });

      markersApplied.forEach(marker => {
        marker.icon = iconApplied;
        map.addMarker(marker);
      });

      const markersAll = markersPending.concat(markersApplied);
      markersAll.forEach(hash => {
        markers.push({ lat: hash.lat, lng: hash.lng });
      });
    } else {
      const marker = JSON.parse(mapElement.dataset.marker);
      const icon = {
        url: red,
        size: new google.maps.Size(32, 40),
        origin: new google.maps.Point(0, 0),
        anchor: new google.maps.Point(16, 40)
      };
      marker[0].icon = icon;
      map.addMarker(marker[0]);
      markers.push({ lat: marker[0].lat, lng: marker[0].lng });
    }
    if (markers.length === 0) {
      map.setZoom(2);
    } else if (markers.length === 1) {
      map.setCenter(markers[0].lat, markers[0].lng);
      map.setZoom(14);
    } else {
      map.fitLatLngBounds(markers);
    }
  }
};

export default initMap;
