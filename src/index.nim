import karax / [kbase, vdom, kdom, vstyles, karax, karaxdsl, jdict, jstrutils, jjson]
import strformat, strutils
from uri import encodeUrl

type
  Site = object
    name: string
    urlFmts: seq[string]

# [![Coverage Status]()](https://coveralls.io/github/jiro4989/textimg?branch=master)

const
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
    tdiv(class = "container"):
      tdiv:
        h1: text "Badges"
        hr()
      tdiv:
        tdiv:
          h2: text "Input"
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
          hr()
        tdiv:
          h2: text "Output"
          tdiv(class = "row"):
            for site in sites:
              tdiv(class = "col s12 m4"):
                tdiv(class = "card blue-grey darken-1"):
                  tdiv(class = "card-content white-text"):
                    span(class = "card-title"):
                      text site.name
                    for urlFmt in site.urlFmts:
                      let url = urlFmt % [user, repo, branch, workflow, workflowName]
                      p:
                        a(href = url):
                          img(src = url, alt = "Build Status")

setRenderer createDom
