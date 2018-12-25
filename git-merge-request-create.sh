#!/bin/bash
#Author: Bell<bell@greedlab.com>
#
# create git merge request
#

usage() {
	echo
	echo "Usage:"
	echo " ${0##*/} [-p <PROJECT NAME>] [-s <SOURCE BRANCH>] [-t <TARGET BRANCH>] [-m <TITLE>] [-d <DISABLE AUTO PUSH>] [-v] [-u] [-h]"
	echo
	echo "Options:"
	echo " -p: target project, default current project"
	echo " -s: source branch, default current branch"
	echo " -t: target branch, default master"
	echo " -m: merge request title, default latest commit"
	echo " -d: whether disable auto push to remote branch, default true, if false disable"
	echo " -v: show version"
	echo " -u: check update"
	echo " -h: show help"
	echo
	echo "Example 1:"
	echo " ${0##*/} -p greedbell/git-merge-request -s test -t master -m title -d"
	echo "Example 2"
	echo " ${0##*/}"
	echo
}

checkAccessToken() {
	if [[ -z ${GITLAB_ACCESS_TOKEN} ]]; then
		echo You must export GITLAB_ACCESS_TOKEN to env first
		echo You can generate Gitlab Access Token from Gitlab Tokens >Settings >Access
		exit 1
	fi
}

checkShellEnv() {
	hash jq || brew install jq || exit 1
}

urlencode() {
	# urlencode <string>
	local length="${#1}"
	for ((i = 0; i < length; i++)); do
		local c="${1:i:1}"
		case $c in
		[a-zA-Z0-9.~_-]) printf "$c" ;;
		*) printf '%%%02X' "'$c" ;;
		esac
	done
}

urldecode() {
	# urldecode <string>
	local url_encoded="${1//+/ }"
	printf '%b' "${url_encoded//%/\\x}"
}

version=0.1.1
while getopts 'p:s:t:m:d:vuh' arg; do
	case $arg in
	p) gitlab_project_name=$OPTARG ;;
	s) source=$OPTARG ;;
	t) target=$OPTARG ;;
	m) title=$OPTARG ;;
	d) disable_auto_push=1 ;;
	v)
		echo ${version}
		exit 0
		;;
	u)
		curl -o- "https://raw.githubusercontent.com/greedbell/git-merge-request/master/git-merge-request-install.sh" | /bin/sh
		exit 0
		;;
	h)
		usage
		exit 0
		;;
	?)
		usage
		exit 1
		;;
	esac
done

if [[ -z $gitlab_project_name ]]; then
	if [[ -z ${gitlab_project_name} ]]; then
		gitlab_project_name=$(git config --local remote.origin.url) || exit 1
		gitlab_project_name=${gitlab_project_name##*:}
		gitlab_project_name=${gitlab_project_name%.*}
	fi
fi

if [[ -z $source ]]; then
	source=$(git branch | grep \* | cut -d ' ' -f2) || exit 1
fi

if [[ -z $target ]]; then
	target="master"
fi

if [[ -z $title ]]; then
	title=$(git log -1 --pretty=format:"%B") || exit 1
fi

if [[ -z $disable_auto_push ]]; then
	current_branch=$(git branch | grep \* | cut -d ' ' -f2) || exit 1
	git push origin ${current_branch}
fi

if [[ -z ${GITLAB_API_ADDRESS} ]]; then
	GITLAB_API_ADDRESS="https://gitlab.com/api/v4"
fi

checkShellEnv
checkAccessToken

project_id=$(urlencode $gitlab_project_name)

# test gitlab api
curl --silent --header "PRIVATE-TOKEN: ${GITLAB_ACCESS_TOKEN}" "${GITLAB_API_ADDRESS}/projects/${project_id}" >/dev/null || exit 1

# create merge request
# @ref https://github.com/gitlabhq/gitlabhq/blob/master/doc/api/merge_requests.md#create-mr

merge_request=$(curl --silent --request POST \
	--header "PRIVATE-TOKEN: ${GITLAB_ACCESS_TOKEN}" \
	"${GITLAB_API_ADDRESS}/projects/${project_id}/merge_requests" \
	--form "source_branch=${source}" \
	--form "target_branch=${target}" \
	--form "title=${title}")
echo ${merge_request} | jq 'if has("web_url") == true then {title, address: .web_url, state, created_at} else .message end'
