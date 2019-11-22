import karax / [kbase, vdom, kdom, vstyles, karax, karaxdsl, jdict, jstrutils, jjson]
import strformat, strutils
from uri import encodeUrl

type
  Site = object
    name: string
    urlFmts: seq[string]

# [![Coverage Status]()](https://coveralls.io/github/jiro4989/textimg?branch=master)

const
  baseColor = "blue-grey darken-1"
  cardColor = "blue-grey darken-2"
  textColor = "blue-grey-text darken-3"
  sites = @[
    Site(name: "GitHub Actions", urlFmts: @["https://github.com/$1/$2/workflows/.github/workflows/$4/badge.svg", "https://github.com/$1/$2/workflows/$5/badge.svg"]),
    Site(name: "TravisCI", urlFmts: @["https://travis-ci.org/$1/$2.svg?branch=$3"]),
    Site(name: "CircleCI", urlFmts: @["https://circleci.com/gh/$1/$2/tree/$3.svg?style=svg"]),
    Site(name: "Coveralls", urlFmts: @["https://coveralls.io/repos/github/$1/$2/badge.svg?branch=$3"]),
    ]

var
  user, userBuf, repo, repoBuf, workflow, workflowBuf, workflowName, workflowNameBuf: string
  branchBuf = "master"
  branch = branchBuf

proc editUser(ev: Event; n: VNode) =
  userBuf = $n.value

proc editRepo(ev: Event; n: VNode) =
  repoBuf = $n.value

proc editBranch(ev: Event; n: VNode) =
  branchBuf = $n.value

proc editWorkflow(ev: Event; n: VNode) =
  workflowBuf = $n.value

proc editWorkflowName(ev: Event; n: VNode) =
  workflowNameBuf = encodeUrl($n.value, usePlus = false)

proc createDom(): VNode =
  result = buildHtml(tdiv):
    nav:
      tdiv(class = &"nav-wrapper {baseColor}"):
        a(class = "brand-logo"): text "Badges"
    tdiv(class = "container"):
      tdiv:
        tdiv(class = "section"):
          h2(class = textColor): text "Input"
          tdiv(class = "row"):
            # 3 column
            let cls = "input-field col s" & $(12/3)
            tdiv(class = cls):
              input(`type` = "text", id = "userInput", onkeyup = editUser)
              label(`for` = "userInput"): text "User"
            tdiv(class = cls):
              input(`type` = "text", id = "repoInput", onkeyup = editRepo)
              label(`for` = "repoInput"): text "Repository"
            tdiv(class = cls):
              input(`type` = "text", id = "branchInput", value = "master", onkeyup = editBranch)
              label(`for` = "branchInput"): text "Branch"
            tdiv(class = cls):
              input(`type` = "text", id = "workflowInput", onkeyup = editWorkflow, placeholder = "workflow.yml")
              label(`for` = "workflowInput"): text "GitHub Actions workflow file"
            tdiv(class = cls):
              input(`type` = "text", id = "workflowNameInput", onkeyup = editWorkflowName)
              label(`for` = "workflowNameInput"): text "GitHub Actions workflow name"
          tdiv(class = "row"):
            button(class = "waves-effect waves-light btn"):
              text "Show"
              proc onclick(ev: Event, n: VNode) =
                user = userBuf
                repo = repoBuf
                branch = branchBuf
                workflow = workflowBuf
                workflowName = workflowNameBuf
        tdiv(class = "section"):
          h2(class = textColor): text "Output"
          tdiv(class = "row"):
            for site in sites:
              tdiv(class = "col s12 m4", style = style(StyleAttr.height, cstring"200px")):
                tdiv(class = &"card {cardColor}"):
                  tdiv(class = "card-content white-text"):
                    span(class = "card-title"):
                      text site.name
                    for urlFmt in site.urlFmts:
                      let url = urlFmt % [user, repo, branch, workflow, workflowName]
                      p:
                        a(href = url):
                          img(src = url, alt = "Build Status")
    footer(class = &"page-footer {baseColor}"):
      tdiv(class = "footer-copyright"):
        tdiv(class = "container"):
          text "© 2019 jiro4989, "
          a(href = "https://github.com/jiro4989/badges"): text "Repository"
          text ", MIT License"

setRenderer createDom