#lang pollen
@(local-require pollen/template)
@(define (attr->string attr)
   (string-append
    (symbol->string (first attr))
    "="
    "\"" (second attr) "\""))

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>@|title|</title>
    <meta name="description" content="@|description|">
    <meta name="author"      content="@|author|">
    <meta name="keywords"    content="@|keywords|">
    <meta name="viewport"    content="width=device-width, initial-scale=1.0">
    <link rel="icon"      href="@|uri-prefix|/favicon.ico">
    <link rel="canonical" href="@|full-uri|">

    @(when rel-next @list{<link rel="next" href="@|rel-next|">})
    @(when rel-prev @list{<link rel="prev" href="@|rel-prev|">})

    <!-- CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
	  integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <link rel="stylesheet" type="text/css" href="@|uri-prefix|/css/pygments.css">
    <link rel="stylesheet" type="text/css" href="@|uri-prefix|/css/scribble.css">
    <link rel="stylesheet" type="text/css" href="@|uri-prefix|/css/custom.css">
    <!-- Feeds -->
    <link rel="alternate" type="application/atom+xml"
          href="@|atom-feed-uri|" title="Atom Feed">
    <!-- <link rel="alternate" type="application/rss+xml" -->
    <!--       href="@|rss-feed-uri|" title="RSS Feed"> -->
    <!-- JS -->
    <script src="https://use.fontawesome.com/f9f3cd1f14.js"></script>
    @google-universal-analytics["UA-xxxxx"]
  </head>
  <body>
    <nav class="navbar navbar-default">
      <div class="container">
        <div class="navbar-header">
          <button type="button"
                  class="navbar-toggle"
                  data-toggle="collapse"
                  data-target=".our-nav-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a href="@|uri-prefix|/index.html" class="navbar-brand">如月.飛羽</a>
        </div>
        <div class="collapse navbar-collapse our-nav-collapse"
             role="navigation">
          <ul class="nav navbar-nav">
	    @;{ Add "active" class if uri's active }
            @(define (nav-item uri label [a-attribs ""])
              @list{
                <li @(when (string-ci=? uri uri-path)
		           (attr->string '(class "active")))>
                  <a href="@|uri|"@|a-attribs|>@|label|</a>
                </li> })
            <li class="dropdown">
              <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                標籤 <b class="caret"></b></a>
              <ul class="dropdown-menu">
                <li><a href="@|uri-prefix|/index.html">所有文章</a></li>
                @|tags-list-items|
              </ul>
            </li>
            @nav-item[(string-append uri-prefix "/about.html") "關於"]
          </ul>
	</div>
      </div>
    </nav>
    <div class="container">
      <div class="row">
        <div id="content" class="col-md-12">
          @(when (string-ci=? uri-path
                              (string-append uri-prefix
                                             "/index.html"))
            @list{
              <h1>Welcome</h1>
              <p></p> })
          @;{ Index pages for posts have @tag that's not #f }
          @(when tag
            @list{<h1>@"@"<em>@|tag|</em></h1>})
          @|contents|
        </div>
      </div>
      <footer>
        <hr />
	<a rel="license"
	   href="http://creativecommons.org/licenses/by/4.0/">
	  <img alt="Creative Commons License"
	       style="border-width:0"
	       src="https://i.creativecommons.org/l/by/4.0/88x31.png" />
	</a>
	<br />
	<p>© Kisaragi Hiu 2017. Posts are licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/4.0/">CC-BY-NC 4.0 International license</a>.</p>
        <div>
	  <a href="@|atom-feed-uri|">
	    ◊font-awesome["fa-rss-square"]
	  </a>
	  ◊twitter["flyin1501"]{
	    ◊font-awesome["fa-twitter-square" #:txexpr #t]
	  }
	</div>
        <p>Site generated
        by <a href="https://github.com/greghendershott/frog">Frog</a>,
        the <strong>fr</strong>ozen bl<strong>og</strong> tool.</p>
      </footer>
    </div>
    <!-- </body> JS -->
    <script type="text/javascript" src="//code.jquery.com/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
  </body>
</html>