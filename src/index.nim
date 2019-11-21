import karax / [kbase, vdom, kdom, vstyles, karax, karaxdsl, jdict, jstrutils, jjson]
import strformat, strutils

type
  Site = object
    name, urlFmt: string

const
  sites = @[
    Site(name: "GitHub Actions", urlFmt: "https://travis-ci.org/$1/$2.svg?branch=master"),
    Site(name: "Nimble directory", urlFmt: "https://travis-ci.org/$1/$2.svg?branch=master"),
    Site(name: "TravisCI", urlFmt: "https://travis-ci.org/$1/$2.svg?branch=master"),
    Site(name: "CircleCI", urlFmt: "https://travis-ci.org/$1/$2.svg?branch=master"),
    Site(name: "GitLabCI", urlFmt: "https://travis-ci.org/$1/$2.svg?branch=master"),
    ]

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
    ul:
      li:
        text "User:"
        input(`type` = "text", id = "userInput", onkeyup = editUser)
      li:
        text "Repository:"
        input(`type` = "text", id = "repoInput", onkeyup = editRepo)
    hr()
    h2:
      text "Output"
    tdiv:
      for site in sites:
        h3:
          text site.name
        let url = site.urlFmt % [user, repo]
        a(href = url):
          img(src = url, alt = "Build Status")

setRenderer createDom
