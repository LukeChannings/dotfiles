/**
  {
    "api":1,
    "name":"Parse JSON",
    "description":"Parses a value as JSON and returns the parsed result",
    "author":"Luke Channings",
    "icon":"quote",
    "tags":"add,slashes,escape"
  }
**/
function main(state) {
  let selectedText = state.selection

  try {
    state.text = JSON.parse(selectedText)
  } catch (err) {
     state.postError(`Didn't work. ${err}`)
  }
}
