import GMaps from 'gmaps/gmaps.js';

const initMap = () => {
  const mapElement = document.getElementById('map');
  if (mapElement) {
    const map = new GMaps({ el: '#map', lat: 0, lng: 0 });
    const markers_pending = JSON.parse(mapElement.dataset.pending);
    const markers_applied = JSON.parse(mapElement.dataset.applied);

    let pinColor = "dd0a35";
    let pinImage = new google.maps.MarkerImage("http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|" + pinColor);
    markers_pending.forEach(marker => {
      marker.icon = pinImage
      map.addMarker(marker)
    });

    pinColor = "0b409c";
    pinImage = new google.maps.MarkerImage("http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|" + pinColor);
    markers_applied.forEach(marker => {
      marker.icon = pinImage
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
