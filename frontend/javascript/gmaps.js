import GMaps from 'gmaps/gmaps.js';
import blue from '../images/map-marker-blue.svg';
import red from '../images/map-marker-red.svg';

const initMap = () => {
  const mapElement = document.getElementById("map");
  if (mapElement) {
    const map = new GMaps({ el: '#map', lat: 0, lng: 0 });
    const markersPending = JSON.parse(mapElement.dataset.pending);
    const markersApplied = JSON.parse(mapElement.dataset.applied);


    const iconPending = {
      // Adresse de l'icône personnalisée
      url: blue,
      // Taille de l'icône personnalisée
      size: new google.maps.Size(32, 40),
      // Origine de l'image, souvent (0, 0)
      origin: new google.maps.Point(0,0),
      // L'ancre de l'image. Correspond au point de l'image que l'on raccroche à la carte. Par exemple, si votre îcone est un drapeau, cela correspond à son mâts
      anchor: new google.maps.Point(16,40)
    };

    const iconApplied = {
      // Adresse de l'icône personnalisée
      url: red,
      // Taille de l'icône personnalisée
      size: new google.maps.Size(32, 40),
      // Origine de l'image, souvent (0, 0)
      origin: new google.maps.Point(0,0),
      // L'ancre de l'image. Correspond au point de l'image que l'on raccroche à la carte. Par exemple, si votre îcone est un drapeau, cela correspond à son mâts
      anchor: new google.maps.Point(16,40)
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
    const markers = [];
    markersAll.forEach(hash => {
      markers.push({ lat: hash.lat, lng: hash.lng });
    });

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
