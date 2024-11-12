const path = require('path');
const rspack = require('@rspack/core');

module.exports = {
  mode: 'production',
  entry: './src/index.ts',
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: '[name].js',
  },
  module: {
    rules: [
      {
        test: /\.ts$/,
        use: {
          loader: 'builtin:swc-loader',
          options: {
            jsc: {
              parser: {
                syntax: 'typescript',
              },
            },
          },
        },
        exclude: /node_modules/,
      },
      {
        test: /\.module\.css$/,
        type: 'css/module', // Changed this line
        use: {
          loader: 'postcss-loader', // Optional, if you need PostCSS processing
        },
      },
    ],
  },
  plugins: [
    new rspack.HtmlRspackPlugin(),
  ],
  resolve: {
    extensions: ['.ts', '.js'],
  },
  optimization: {
    minimize: true,
  },
};