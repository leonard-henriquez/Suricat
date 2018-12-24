const tagGenerator = (tag, displayProperty) => `
    <div id="${tag.id}" class="tags">${tag[displayProperty]}</div>
    <input type="hidden" id="hidden-${
      tag.id
    }" name="importance[values][]" value='${JSON.stringify(tag)}'>
  `;

const addTag = (input, tag, displayProperty) => {
  input.insertAdjacentHTML("beforebegin", tagGenerator(tag, displayProperty));
  const tagElem = document.getElementById(tag.id);
  const tagInput = document.getElementById(`hidden-${tag.id}`);
  tagElem.addEventListener("click", () => {
    tagElem.remove();
    tagInput.remove();
  });
};

// const loadTags = (input) => {
//   document.addEventListener("turbolinks:load", () => {
//     if (!input || typeof tagData === 'undefined') {
//       return;
//     }

//     $.each(tagData, (i, tag) => {
//       addTag(input, tag);
//     });
//   });
// };

const test = () => {
  // const tags = [
  //   {
  //     city: "XXXX",
  //     id: "ChIJEW4ls3nVwkcRYGNkgT7xCgQ",
  //     lat: 50.62924999999999,
  //     lng: 3.057256000000052
  //   },
  //   {
  //     city: "YYYY",
  //     id: "ChIJD7fiBh9u5kcRYJSMaMOCCwQ",
  //     lat: 48.85661400000001,
  //     lng: 2.3522219000000177
  //   }
  // ];
  const input = $("#importance__value[data-location='true']")[0];
  $.each(tags, (i, tag) => {
    addTag(input, tag, "city");
  });
};

export default test;
