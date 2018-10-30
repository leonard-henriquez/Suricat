import Chart from 'chart.js';

$(document).ready(() => {
  new Chart(document.getElementById("chartjs"), {
    "type":"radar",
    "data": {
      "labels":["Eating","Drinking","Sleeping","Designing","Coding","Cycling"],
      "datasets": [
        {
          "label":"My criteria",
          "data": [65,59,90,81,56,55],
          "fill":true,
          "backgroundColor":"rgba(255, 99, 132, 0.2)",
          "borderColor":"rgba(208, 137, 37, 0.67)",
          "pointBackgroundColor":"rgb(255, 99, 132)",
          "pointBorderColor":"#fff",
          "pointHoverBackgroundColor":"#fff",
          "pointHoverBorderColor":"rgb(255, 99, 132)"
        }
      ]
    },
    "options": {
      "elements": {
        "line": {
          "tension":0,
          "borderWidth":3
        }
      },
      "scale": {
        "ticks": {
          "beginAtZero": true,
          "showLabelBackdrop": false
        },
        "pointLabels": {
          "fontSize": 20,
        }
      }
    }
  });
})
