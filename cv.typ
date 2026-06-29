// Imports
#import "@preview/brilliant-cv:4.0.1": cv

// Each profile lives in its own folder with a self-contained metadata.toml.
// Switch profile at compile time:
//   typst compile cv.typ --input profile=nl
#let profile = sys.inputs.at("profile", default: "en")
#let metadata = toml("profile_" + profile + "/metadata.toml")

#let import-modules(modules) = {
  for module in modules {
    include {
      "profile_" + profile + "/" + module + ".typ"
    }
  }
}

#show: cv.with(
  metadata,
  profile-photo: image("assets/photo.png"),
)

// Add, remove, or reorder modules to customize your CV content
#import-modules((
  "experience",
  "education",
  "technologies",
  "hobbies",
  "languages",
))
