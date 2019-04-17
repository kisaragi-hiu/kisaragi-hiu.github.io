#lang pollen
◊define-meta[title]{A Makefile for UTAU}
◊define-meta[date]{2019-04-17T19:50:52}
◊define-meta[category]{Tutorial}
◊define-meta[language]{en}

I'm currently making a new cover using UTAU, after having broken the last streak of covers. This time, I thought I'd try using ◊command{make} to help with rendering.

My biggest obstacle is automating the rendering itself: I don't know if UTAU has a command line interface, and using ◊command{xdotool} proved to be too unreliable when I tried. (It was frustrating.)

◊tweet["https://twitter.com/flyin1501/status/1116410591747305472"
       #:summary "How do I render a UST from the command line…"
       #:author "如月飛羽🌈"
       #:profile "flyin1501"
       #:date "2019年4月11日"]

As it turned out, automating the rest of the rendering process is still really helpful. Here is the Makefile for UTAU projects◊ref[]:

◊highlight['make]{
UTAU = env WINEPREFIX=/home/kisaragi-hiu/.wineprefix/UTAU wine "C:\\Program Files (x86)\\UTAU\\utau.exe"
WAV = V1…R1.wav V2…R2.wav harm.wav intro.wav outro.wav ああ-harm.wav ああ-main.wav intro-harm.wav outro-harm.wav

render: $(WAV)
.PHONY: render

$(WAV): %.wav: %.ust
	$(UTAU) "$(realpath $<)"
}

Which simply runs ◊code{$(UTAU) <ust full path>} for each UST that's newer than its corresponding output file. The caveat here is that the UST needs to share its name with its output, which has to be set manually.

Now when I run ◊code{make render}, UTAU windows will pop up one by one for me to manually do the render◊ref[""]. This may not be quite automatic, but it's at least better than manually opening every UST in the project and rendering them.

◊references{
◊reftxt{References used: ◊link["https://learnxinyminutes.com/docs/make/"]{Learn X in Y minutes}, ◊link["https://medium.freecodecamp.org/eec453adf7fe"]{Use `make`! by freeCodeCamp}, and ◊link["https://www.gnu.org/software/make/manual/html_node/File-Name-Functions.html"]{File Name Functions in the manual}.}
◊reftxt{◊kbd{Alt-p g RET} if the output file name has been set.}
}
