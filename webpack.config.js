const path = require('path');

module.exports = {
  entry: './src/js/index.js',
  output: {
    filename: 'main.js',
    path: path.resolve(__dirname, 'dist')
  },
  module: {
    rules: [
      { test: /\.css$/,
        use:['style-loader','css-loader']
      },
      { test: /\.coffee$/,
        use: [ 'coffee-loader' ]
      },
      { test: /.pug$/,
        use: { loader: 'pug-loader',
                query: {} // Can be empty
        }
      }
    ]
  }

};
