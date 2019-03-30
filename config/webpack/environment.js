const { environment } = require("@rails/webpacker");
const webpack = require("webpack");
const erb = require("./loaders/erb");

environment.plugins.prepend(
  "Provide",
  new webpack.ProvidePlugin({
    $: "jquery",
    jQuery: "jquery",
    jquery: "jquery",
    "window.Tether": "tether",
    Popper: ["popper.js", "default"]
  })
);

module.exports = {
  module: {
    rules: [
      {
        test: require.resolve("jquery"),
        use: [
          {
            loader: "expose-loader",
            options: "$"
          }
        ]
      }
    ]
  }
};

environment.loaders.prepend("erb", erb);
environment.loaders.delete("nodeModules");
module.exports = environment;
