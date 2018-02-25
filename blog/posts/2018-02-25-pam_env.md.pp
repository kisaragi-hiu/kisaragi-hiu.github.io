#lang pollen
    Title: Switching to .pam_environment for environment variables
    Date: 2018-02-25T21:34:45
    Tags: language:en, category:kisaragi, Linux, Pollen, Programming, Configuration

The past month my system environment was in quite a mess.

I used to put my environment variables in ◊filepath["~/.profile"]. However, one day, the file simply stopped being sourced. I tried to switch my display manager from sddm, to gdm, then to lightdm, to no avail. I know sourcing a file on login is somewhat insecure, and ◊filepath["~/.pam_environment"] is probably the right way going forward, so I started moving variables into it.

## Preprocessing .pam_environment

I had a piece of code in my ◊filepath["~/.profile"] that checks Racket and Ruby's versions and sets the PATH to point to `raco` and `gem`'s bin directory. Now, ◊filepath["~/.pam_environment"] can't do that, so I wrote a Pollen version of the file and rendered / compiled it into the final ◊filepath["~/.pam_environment"].

◊highlight['racket]|{
◊(define (defpam_env name . contents)
   (define content (string-join contents ""))
   ◊string-append{◊|name| DEFAULT=◊|content|})

◊(define (pathlist-string . args)
   (string-join (string-split (string-join args "") "\n") ":"))

◊(define racket-version (version))
◊(define ruby-version
   ; this, or sed | cut? I don't know which I prefer really.
   ((compose1 first
              (λ ($1) (string-split $1 "p"))
              second
              (λ ($1) (string-split $1 " ")))
    (with-output-to-string (λ () (system "ruby --version")))))

◊; == directory shortcuts ==
◊defpam_env["XDG_DESKTOP_DIR"]{◊|HOME|/デスクトップ}
◊defpam_env["XDG_DOWNLOAD_DIR"]{◊|HOME|/ダウンロード}
◊; ...

◊defpam_env["PATH"]{◊pathlist-string{
◊|HOME|/git/scripts
◊|HOME|/git/Sudocabulary
◊|HOME|/bin
◊|HOME|/.racket/◊|racket-version|/bin
◊|HOME|/.local/share/npm-global/bin
◊|HOME|/.gem/ruby/◊|ruby-version|/bin
$◊"{"PATH◊"}"
/usr/bin ◊; safety fallback
}}

◊; ...

◊defpam_env["VISUAL"]{nvim}
◊defpam_env["EDITOR"]{nvim}
}|

It's really ugly, but it only has one job, which it does fine.

## DEFAULT? OVERRIDE? pam_env, what?

All seemed well, until a few days later my PATH config isn't taking effect anymore. For some reason, every other variable is properly set, just not PATH. Trying to see just exactly which file those variables came from, I noticed a variable that is only present in my ◊filepath["~/.pam_environment"], telling me that it is indeed being read. I looked up info on PATH not being set with ◊filepath[".pam_environment"], and found [this StackExchange post](https://superuser.com/questions/130135/why-doesnt-my-environment-variable-get-set) hinting at something to do with the `var DEFAULT=value` syntax.

Reading into pam_env's documentation on the config format, it seems that `DEFAULT` is intended to be used for, well, defaults that could be overridden. Changing it into OVERRIDE seems to tell pam_env to just use the value and don't fiddle around.

◊highlight['racket]|{
◊(define (defpam_env name . contents)
   (define content (string-join contents ""))
   ; DEFAULT -> OVERRIDE.
   ◊string-append{◊|name| OVERRIDE=◊|content|})
}|

The full configuration file can be found [in my dotfiles repo](https://github.com/flyingfeather1501/dotfiles/blob/master/@linux/.pam_environment.pp).
