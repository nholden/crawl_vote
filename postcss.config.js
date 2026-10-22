module.exports = {
  plugins: [
    require('postcss-import'),
    require('postcss-cssnext'),
    require('tailwindcss')('./app/javascript/tailwind/tailwind.js')
  ]
}
