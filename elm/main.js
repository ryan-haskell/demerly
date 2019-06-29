import { Elm } from './src/Main.elm'

const app = Elm.Main.init({
  node: document.getElementById('app'),
  flags: window.__FLAGS__
})

app.ports.outgoing.subscribe(_ =>
  window.scrollTo(0, 0)
)
