ELM_JS=public/assets/js/elm.js

run: build
	elm-reactor

build:
	elm-make src/Main.elm --output $(ELM_JS) --warn


# npm install uglify-js -g
compress:
	uglifyjs --compress --mangle -o $(ELM_JS) -- $(ELM_JS)
