const path = require('path');

module.exports = {
  entry: [ './src/coffee/black.coffee',
           './src/css/main.css'
         ],
  output: {
    filename: 'demo.js',
    path: path.resolve(__dirname, 'dist'),
  },
  module: {
    rules: [
      { test: /\.css$/,
        include: [
          path.resolve(__dirname, 'src/css'),
        ],
        use:['style-loader','css-loader']
      },
      { test: /\.coffee$/,
        include: [
          path.resolve(__dirname, 'src/coffee')
        ],
        use: [ 'coffee-loader' ]
      },
      { test: /.pug$/,
        include: path.resolve(__dirname, 'src/pug'),
        use: { loader: 'pug-loader',
                query: {} // Can be empty
        }
      },
      { test: require.resolve('jquery'),
        use: [{
          loader: 'expose-loader',
          options: '$'
        }]
      }
    ]
  }

};
