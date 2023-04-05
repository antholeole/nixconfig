#let notes(
  subject: none,
  name: "Anthony Oleinik",
  paper-size: "us-letter",
  body
) = {
  set document(
    title: subject,
    author: name
  )

  set text(
    size: 12pt, 
    font: "Fira"
  )

  set page(
    margin: (top: 2cm)
  )

  set align(end)
  name

  set align(start)
  body
  
  v(1.25cm)
}