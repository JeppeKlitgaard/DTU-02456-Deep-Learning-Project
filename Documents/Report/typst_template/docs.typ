#import "@preview/tidy:0.4.3"
#import "template.typ": abstract, course, names

#let scope = (
  abstract: abstract,
  course: course,
  names: names,
)

#let docs = tidy.parse-module(
  read("template.typ"),
  scope: scope,
)

#tidy.show-module(docs, show-outline: false)
