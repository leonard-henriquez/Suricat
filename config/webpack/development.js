process.env.NODE_ENV = process.env.NODE_ENV || "development";

const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const environment = require("./environment");

module.exports = {
  plugins: [
    new MiniCssExtractPlugin({
      filename: "[name].css",
      chunkFilename: "[id].css"
    })
  ],
  module: {
    rules: [
      {
        test: /\.(sa|sc|c)ss$/,
        use: ["style-loader", "css-loader", "postcss-loader", "sass-loader"]
      }
    ]
  }
};

module.exports = environment.toWebpackConfig();
