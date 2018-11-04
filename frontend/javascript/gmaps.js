import GMaps from "gmaps/gmaps";

const pin = color =>
  new google.maps.MarkerImage(
    `http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|${color}`
  );

const initMap = () => {
  const mapElement = document.getElementById("map");
  if (mapElement) {
    const map = new GMaps({ el: "#map", lat: 0, lng: 0 });

    const markersPending =
      $("mapElement").data("pending") !== undefined
        ? JSON.parse($("mapElement").data("pending"))
        : [];
    const markersApplied =
      $("mapElement").data("applied") !== undefined
        ? JSON.parse($("mapElement").data("applied"))
        : [];

    markersPending.forEach(marker => {
      marker.icon = pin("dd0a35");
      map.addMarker(marker);
    });

    markersApplied.forEach(marker => {
      marker.icon = pin("0b409c");
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
