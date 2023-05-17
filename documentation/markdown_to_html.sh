#!/usr/bin/env bash

CSS_FILE="github-pandoc.css"

for MARKDOWN_FILE in *.md; do
	HTML_FILE="${MARKDOWN_FILE%.md}.html"
	pandoc "${MARKDOWN_FILE}" -f markdown -t html -s -o "${HTML_FILE}" --css="${CSS_FILE}" --self-contained
done
