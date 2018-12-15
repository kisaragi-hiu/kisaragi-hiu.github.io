#lang pollen
◊; This file is fed through pollen first.
◊; This `require`s eg. ->html for use as a preprocessor.
◊(require pollen/template)

@; This needs local-require as it's a template
@(local-require (only-in xml string->xexpr)
                txexpr
                json
                threading
                racket/format
                racket/string
                pollen/template/html
                "tags.rkt"
                "define-txexpr.rkt"
                "widgets.rkt"
                "translate.rkt"
                "content-processing.rkt")

@(define all-tags (tag-string->tags tags-list-items))
◊; Return txexpr from frog template
@(current-return-txexpr? #t)
◊; Return HTML from Pollen
◊(void (current-return-txexpr? #f))

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>@|title|</title>
    <meta name="description" content="@|description|">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="author" content="@|author|">
    <meta name="keywords" content="@|keywords|">
    <link rel="icon" href="@|uri-prefix|/favicon.ico">
    <link rel="canonical" href="@|full-uri|">

    @(when rel-next @list{<link rel="next" href="@|rel-next|">})
    @(when rel-prev @list{<link rel="prev" href="@|rel-prev|">})
    ◊; Font
    @(->html
      `((link ([rel "stylesheet"]
               [href "https://fonts.googleapis.com/css?family=Fira+Sans%7COverpass+Mono%7COverpass:400,600"]))
        (link ([rel "stylesheet"]
               [href "https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css"]
               [integrity "sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO"]
               [crossorigin "anonymous"]))
        (link ([rel "stylesheet"]
               [href "/css/emacs.css"]))
        (link ([rel "stylesheet"]
               [href "/css/main.css"]))
        (link ([rel "alternate"]
               [type "application/atom+xml"]
               [href ,atom-feed-uri]
               [title "Atom Feed"]))
     ))
  </head>
  <body>
    <!--[if lte IE 9]>
      ◊; … too aggressive?
      ◊(->html '(h1 "For the love of god, please stop using IE9. Thanks."))
    <![endif]-->
    <a id="top"></a>

    <div class="container">
      ◊; Header
      <header id="header" class="py-2">
        <div class="row flex-nowrap justify-content-between alien-items-center">
          <div id="logo" class="col-6 pt-1">
            <div class="d-flex justify-content-begin">
              <a href="/" target="_self" class="py-2 pr-2"><img src="/images/avatar.png" alt="Kisaragi Hiu"/></a>
              <h1 style="margin-top: 0.4em;">Kisaragi&nbsp;Hiu</h1>
            </div>
          </div>
          <div class="col-6 nav-scroller py-1">
            <nav class="nav d-flex justify-content-end">
              <a class="p-2 text-secondary" href="/">Blog</a>
              @(dropdown
                #:return-txexpr? #f
                #:button-id "dropdownLanguages"
                #:button-extra-classes "text-secondary p-2"
                #:button-label "Languages"
                '(button
                  ([onclick "(() => document.documentElement.lang = 'zh')()"])
                  "中文")
                ◊; '(button
                ◊;   ([onclick "(() => document.documentElement.lang = 'ja')()"])
                ◊;   "日本語")
                '(button
                  ([onclick "(() => document.documentElement.lang = 'en')()"])
                  "English"))
              @(apply
                dropdown
                #:return-txexpr? #f
                #:button-id "dropdownTags"
                #:button-extra-classes "text-secondary p-2"
                #:button-label "Tags"
                (tags->link/txexpr (filter-not special? all-tags)))
              ◊; @(get-category-tags all-tags)
              ◊; <li><a href="@|uri-prefix|/categories.html">Categories</a></li>
            </nav>
          </div>
        </div>
      </header>

      ◊; Contents
      <div id="content" class="">
        @(if (index? contents)
             ◊; When the current page is an index
             (begin
               (let* ([indices (string->indices contents)]
                      [filtered-indices
                       (~>
                        (filter-not
                         ;; filter out nothing.
                         ;; add things to filter out here
                         (lambda (_x) #f)
                         indices))]
                      [years (get-years-in-indices filtered-indices)]
                      ◊; tags are available in all-tags already
                      [categories (filter category? all-tags)])
                 ◊; Top section
                 (string-append
                   (cond [(special? tag)
                          (xexpr->string `(h1 ,(string-titlecase
                                                (tag-special-prefix tag))
                                              ": "
                                              (strong ,(strip-tag-special-prefix tag))))]
                         [tag
                          (xexpr->string `(h1 ,(! "Tag") ": " (strong ,tag)))]
                         [else
                          ◊; at index page
                          ◊; This is where the landing text should be
                          (~a
                           @~a{
<div class="d-flex justify-content-begin">
  ◊link["@|atom-feed-uri|" #:class "py-2"]{
    ◊font-awesome["rss" #:color "6c757d"]
  }
  ◊twitter["flyin1501" #:class "p-2"]{
    ◊font-awesome["twitter" #:color "6c757d"]
  }
  ◊github["kisaragi-hiu" #:class "p-2"]{
    ◊font-awesome["github" #:color "6c757d"]
  }
  ◊gitlab["kisaragi-hiu" #:class "p-2"]{
    ◊font-awesome["gitlab" #:color "6c757d"]
  }
  ◊youtube["channel/UCl_hsqcvdX0XdgBimRQ6R3A" #:class "p-2"]{
    ◊font-awesome["youtube-play" #:color "6c757d"]
  }
</div>
<p>◊$[#:en "I'm a college student interested in Free Software, programming, VOCALOID / UTAU culture, and language learning."
      #:zh "語言學習、自由軟體、程式、VOCALOID / UTAU 文化相關。"]</p>
<p>◊!{Contact:}<br>contact@"@"kisaragi-hiu.com</p>
                           }
                           (collapse
                            #:return-txexpr? #f
                            #:div-id "collapseWorks"
                            #:div-extra-classes "show"
                            #:button-classes "index-stream-title"
                            #:button-label "Works"
                            (collapse
                             #:div-id "collapseCode"
                             #:div-extra-classes "show"
                             #:button-classes "collapse-level-2 text-secondary"
                             #:button-label "Code"
                             `(ul ([class "project-list"])
                              ,(project "https://github.com/kisaragi-hiu/cangjie.el"
                                        "Cangjie.el"
                                        ($ #:en "Retrieve Cangjie code for Han character in Emacs."
                                           #:zh "在 Emacs 中查漢字的倉頡碼。"))
                              ,(project "https://github.com/kisaragi-hiu/tr.el"
                                        "Tr.el"
                                        ($ #:en "Minimal tr implementation for Emacs."
                                           #:zh "簡單的 tr 實作。"))
                              ,(project "https://gitlab.com/kisaragi-hiu/dotfiles/tree/master/scripts/.local/bin"
                                        "Scripts"
                                        ($ #:en "Small scripts I've written over the years."
                                           #:zh "幾年來寫的小腳本。"))
                              ,(project "https://gitlab.com/kisaragi-hiu/language-startup-benchmark"
                                        "Language Startup Benchmark"
                                        ($ #:en "Time hello world in various languages to benchmark their startup times."
                                           #:zh "為一些語言的 hello world 計時來看它們的啟動時間。"))))
                            (collapse
                             #:div-id "collapseUTAU"
                             #:button-classes "collapse-level-2 text-secondary collapsed"
                             #:button-label "UTAU Covers"
                             '(p "I upload covers on " '(a ([href "https://youtube.com/channel/UCl_hsqcvdX0XdgBimRQ6R3A"]) "Youtube ") "and " '(a ([href "https://www.nicovideo.jp/user/38995186"]) "niconico") ".")
                             `(div ([class "project-list"])
                               ,(youtube/image-link "6rcSTAgQAkM")
                               ,(youtube/image-link "4OsnqVBqPqQ")))
                              )
                           (collapse-button
                            #:return-txexpr? #f
                            #:div-id "collapseBlog"
                            #:button-class "index-stream-title"
                            "Blog")
                          )])

                   "<div class=\"collapse show\" id=\"collapseBlog\">"
                   (string-join
                    ◊; for each year, grab the index items from that year
                    (map (lambda (year)
                           (string-append
                            ◊; not using `collapse` since indices are strings
                            (xexpr->string
                             `(div (a ([class "collapse-level-2 text-secondary"]
                                       [data-toggle "collapse"]
                                       [href ,(~a "#collapseYear" year)]
                                       [role "button"]
                                       [aria-expanded "false"]
                                       [aria-controls ,(~a "collapseYear" year)])
                                      ,year)))
                            "<div class=\"collapse show\" id=\"collapseYear" year "\">"
                            (filter-indices-to-string
                             (lambda (x) (equal? (content-year x) year))
                             filtered-indices)
                            "</div>"))
                         years))
                   "</div>" ◊; collapseBlog
                   )))

             ◊; If not an index, just show the contents
             (strip-metadata contents))
      </div>

      ◊; Footer
      <footer class="">
        <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">
           <img alt="Creative Commons License"
                style="border-width:0"
                src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" />
        </a>
        <br />
        ◊($ #:en `(p "© Kisaragi Hiu 2017~2018. Posts are licensed under a " (a ([rel "license"] [href "http://creativecommons.org/licenses/by-sa/4.0/"]) "CC-BY-SA 4.0 International license") ".")
            #:zh `(p "© Kisaragi Hiu 2017~2018. 文章以" (a ([rel "license"] [href "http://creativecommons.org/licenses/by-sa/4.0/"]) "CC-BY-SA 4.0 國際版授權條款") "釋出。"))
        ◊($ #:en `(p "Site generated with " (a ([href "https://github.com/greghendershott/frog"]) "Frog") ".")
            #:zh `(p "使用" (a ([href "https://github.com/greghendershott/frog"]) "Frog") "。"))
        ◊($ #:en `(p "Preprocessed with " (a ([href "http://pollenpub.com"]) "Pollen") ", the programmable publishing system.")
            #:zh `(p "以" (a ([href "http://pollenpub.com"]) "Pollen") "，可編程的出版系統，進行預處理。"))
        ◊($ #:en `(p "Styled using" (a ([href "https://getbootstrap.com"]) "Bootstrap") ".")
            #:zh `(p "CSS利用" (a ([href "https://getbootstrap.com"]) "Bootstrap") "。"))
      </footer>
    </div>
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"
            integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo"
            crossorigin="anonymous">
    </script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"
            integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49"
            crossorigin="anonymous">
    </script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js"
            integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy"
            crossorigin="anonymous">
    </script>
    ◊; Google Analytics
    <script>
      window.ga = function () { ga.q.push(arguments) }; ga.q = []; ga.l = +new Date;
      ga('create', 'UA-109874076-1', 'auto'); ga('send', 'pageview')
    </script>
    <script src="https://www.google-analytics.com/analytics.js" async defer></script>
  </body>
</html>