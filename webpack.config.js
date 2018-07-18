const path = require('path');

module.exports = {
  entry: './src/js/index.js',
  output: {
    filename: 'main.js',
    path: path.resolve(__dirname, 'dist')
  },
  module: {
    rules: [
      {
        test: /\.css$/,
        use: [ { loader: 'style-loader' },
               { loader: 'css-loader',
                  options: {
                    modules: true
            }
          }
        ]
      }
    ]
  }

};
