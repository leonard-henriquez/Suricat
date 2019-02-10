export const tagGenerator = (tag, displayProperty) => `
    <div id="${tag.id}" class="tags">${tag[displayProperty]}</div>
    <input type="hidden" id="hidden-${tag.id}" name="importance[values][]" value='${JSON.stringify(tag)}'>
  `;

export const addTag = (input, object, displayProperty) => {
  input.insertAdjacentHTML("beforebegin", tagGenerator(object, displayProperty));
  const tagElem = document.getElementById(object.id);
  const tagInput = document.getElementById(`hidden-${object.id}`);
  tagElem.addEventListener("click", () => {
    tagElem.remove();
    tagInput.remove();
  });
};

export const loadTags = (tags, insertBefore, displayProperty) => {
  $.each(tags, (i, tag) => {
    addTag(insertBefore, tag, displayProperty);
  });
};
