#!/usr/bin/env bash

# If a command fails then the deploy stops
set -e


update_algolia() {

	cd ../

	type=`cat config.toml|grep -A 5 "languages.zh-cn.params.search"|grep type|awk -F'"' '{print $2}'`

	if [ "$type" == "algolia" ];then		
		source .env
		node push_algolia_json.js
		printf "\033[0;32m已经更新到 algolia...\033[0m\n"
	fi
}

push_github_io() {
	printf "\033[0;32mDeploying updates to GitHub...\033[0m\n"

	# Build the project.
	hugo -d docs

	# if using a theme, replace with `hugo -t <YOURTHEME>`

	# Go To Public folder
	cd docs

	# Add changes to git.
	git pull
	git add .

	# Commit changes.
	msg="rebuilding site $(date)"
	if [ -n "$*" ]; then
		msg="$*"
	fi
	git commit -m "$msg"

	# Push source and build repos.
	git push origin master
	git push github master
}

main() {
	push_github_io
	update_algolia
}

main
