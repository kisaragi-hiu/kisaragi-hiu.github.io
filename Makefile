export LANG=en_US.UTF-8

bin := node_modules/.bin/

.DEFAULT_GOAL := build

.PHONY: serve clean zip css

watch-css:
	$(bin)sass "static/css/main.scss:static/css/main.css" --watch

watch-hugo:
	hugo server

serve: public static/css/main.css
	(sleep 1 && xdg-open "http://localhost:1313") &
	$(bin)concurrently --kill-others "make watch-css" "make watch-hugo"

clean:
	git clean -Xdf

zip: public.zip

public.zip: public
	cd public/ && 7z a ../public.zip .

# the modified timestamp gets messed up on my system; fix that with
# the `touch`.
public: static/css/main.css
	hugo
	@touch public

static/css/main.css: static/css/main.scss
	$(bin)sass --no-source-map "$<" "$@"
