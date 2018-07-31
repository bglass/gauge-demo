const path = require('path');

module.exports = {
  entry: [ './src/js/entry.js',
           './demo/css/main.css'
         ],
  output: {
    filename: 'main.js',
    path: path.resolve(__dirname, 'dist')
  },

  module: {
    rules: [
      { test: /\.css$/,
        include: [
          path.resolve(__dirname, 'src/css'),
          path.resolve(__dirname, 'demo/css')
        ],
        use:['style-loader','css-loader']
      },
      { test: /\.coffee$/,
        include: [
          path.resolve(__dirname, 'src/coffee'),
          path.resolve(__dirname, 'demo/coffee')
        ],
        use: [ 'coffee-loader' ]
      },
      { test: /.pug$/,
        include: path.resolve(__dirname, 'demo/pug'),
        use: { loader: 'pug-loader',
                query: {} // Can be empty
        }
      },
      { test: require.resolve('jquery'),
        use: [{
          loader: 'expose-loader',
          options: '$'
        }]
      },
      { test: /\.svg$/,
        include: path.resolve(__dirname, 'src/svg'),
        loader: 'svg-inline-loader?classPrefix'
      }
    ]
  }

};
