module.exports = {
  outputDir: './dist',
  publicPath: "./",
  runtimeCompiler: true,
  pluginOptions: {
    quasar: {
      importStrategy: 'kebab',
      rtlSupport: true
    }
  },
  transpileDependencies: [
    'quasar'
  ]
}
