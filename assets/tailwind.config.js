// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

let plugin = require("tailwindcss/plugin");

module.exports = {
  content: ["./js/**/*.js", "../lib/*_web.ex", "../lib/*_web/**/*.*ex"],
  theme: {
    extend: {
      colors: {
        transparent: "",
        current: "currentColor",
        black: "#212427",
        old_rose: "#BB8588",
        mint_cream: "#EDF4ED",
        ultra_violet: "#5B507A",
        air_force_blue: "#6494AA",
      },
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    plugin(({ addVariant }) =>
      addVariant("phx-no-feedback", ["&.phx-no-feedback", ".phx-no-feedback &"])
    ),
    plugin(({ addVariant }) =>
      addVariant("phx-click-loading", [
        "&.phx-click-loading",
        ".phx-click-loading &",
      ])
    ),
    plugin(({ addVariant }) =>
      addVariant("phx-submit-loading", [
        "&.phx-submit-loading",
        ".phx-submit-loading &",
      ])
    ),
    plugin(({ addVariant }) =>
      addVariant("phx-change-loading", [
        "&.phx-change-loading",
        ".phx-change-loading &",
      ])
    ),
  ],
};
