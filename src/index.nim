import karax / [kbase, vdom, kdom, vstyles, karax, karaxdsl, jdict, jstrutils, jjson]
import strformat

var
  user, repo: string

proc editUser(ev: Event; n: VNode) =
  user = $n.value

proc editRepo(ev: Event; n: VNode) =
  repo = $n.value

proc createDom(): VNode =
  result = buildHtml(tdiv):
    h1:
      text "Badge generator"
    hr()
    h2:
      text "Input"
    input(`type` = "text", id = "userInput", onkeyup = editUser)
    input(`type` = "text", id = "repoInput", onkeyup = editRepo)
    hr()
    h2:
      text "Output"
    tdiv:
      h3:
        text "TravisCI"
      a(href = &"https://travis-ci.org/{user}/{repo}.svg?branch=master"):
        img(src = &"https://travis-ci.org/{user}/{repo}.svg?branch=master", alt = "Build Status")

setRenderer createDom
