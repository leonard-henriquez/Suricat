import introJs from "intro.js";

const introductionTutorial = () => {
  introJs()
    .setOption("overlayOpacity", 0)
    .setOption("hidePrev", true)
    .setOption("hideNext", true)
    .setOption("highlightClass", "bg-transparent")
    .start();
};

export default introductionTutorial;
