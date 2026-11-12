const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,html,sanitized,rb}'
  ],
  theme: {
    extend: {
      colors: {
        background: {
          DEFAULT: '#090d16',
          surface: '#111823',
          hover: '#141e2e'
        },
        portfolio: {
          accent: '#00e5ff',
          panel: '#111823'
        }
      },
      fontFamily: {
        sans: ['Geist', ...defaultTheme.fontFamily.sans],
        mono: ['Geist Mono', ...defaultTheme.fontFamily.mono]
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
  ]
}
