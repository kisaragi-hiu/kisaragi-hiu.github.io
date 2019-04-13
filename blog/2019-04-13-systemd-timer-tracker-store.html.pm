#lang pollen
◊define-meta[title]{systemd units to kill a daemon on loop}
◊define-meta[date]{2019-04-13T13:30:20}
◊define-meta[category]{}
◊define-meta[language]{en}

◊code{tracker-store} leaks memory on my system, and after approximately 1 day of uptime, it'll leak everything and send my system into a lockup. The kernel out-of-memory (OOM) killer isn't going to do anything, and I'm not sure if ◊code{earlyoom} is going to help either. This means the simplest solution is just going to be:

◊highlight['sh]{
while true; do
  pkill tracker-store
  sleep 3h
done
}

If I had to do this with Firefox or Chrome, this would be a bit too extreme, but since ◊code{tracker-store} is only supposed to run in the background anyway, I don't mind (or care) if it's getting killed.

So, also wanting to learn systemd timers, I wrote a timer that does what the above script does.

The service file (◊path{~/.config/systemd/user/kill-tracker.service}) that the timer will fire:

◊highlight['systemd]{
[Unit]
Description=Kill tracker-store

[Service]
Type=oneshot
ExecStart=/usr/bin/pkill tracker-store
SuccessExitStatus=0 1
}

Exit status 1 from pkill means the process couldn't be found.

The timer (◊path{~/.config/systemd/user/kill-tracker.timer}):

◊highlight['systemd]{
[Unit]
Description=Kill tracker-store

[Timer]
OnBootSec=15min
OnUnitActiveSec=4h

[Install]
WantedBy=timers.target
}

Then run ◊code{systemctl --user enable --now kill-tracker.timer} to enable and start the timer.
