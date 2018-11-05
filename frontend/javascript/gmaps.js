import GMaps from 'gmaps/gmaps.js';

const initMap = () => {
  const mapElement = document.getElementById('map');
  if (mapElement) {
    const map = new GMaps({ el: '#map', lat: 0, lng: 0 });
    const markers_pending = JSON.parse(mapElement.dataset.pending);
    const markers_applied = JSON.parse(mapElement.dataset.applied);


    const iconPending = {
      // Adresse de l'icône personnalisée
      url: '../images/map-marker-blue.svg',
      // Taille de l'icône personnalisée
      size: new google.maps.Size(25, 40),
      // Origine de l'image, souvent (0, 0)
      origin: new google.maps.Point(0,0),
      // L'ancre de l'image. Correspond au point de l'image que l'on raccroche à la carte. Par exemple, si votre îcone est un drapeau, cela correspond à son mâts
      anchor: new google.maps.Point(0, 20)
    };

    const iconApplied = {
      // Adresse de l'icône personnalisée
      url: '../images/map-marker-red.svg',
      // Taille de l'icône personnalisée
      size: new google.maps.Size(25, 40),
      // Origine de l'image, souvent (0, 0)
      origin: new google.maps.Point(0,0),
      // L'ancre de l'image. Correspond au point de l'image que l'on raccroche à la carte. Par exemple, si votre îcone est un drapeau, cela correspond à son mâts
      anchor: new google.maps.Point(0, 20)
    };

    markers_pending.forEach(marker => {
      marker.icon = iconPending
      map.addMarker(marker)
    });

    markers_applied.forEach(marker => {
      marker.icon = iconApplied
      map.addMarker(marker)
    });

    const markers_all = markers_pending.concat(markers_applied);
    const markers = [];
    markers_all.forEach (hash => {
      markers.push({lat: hash["lat"], lng: hash["lng"]});
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

export { initMap };
