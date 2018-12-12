#!/bin/bash
#Author: Bell<bell@greedlab.com>
#
# list git merge request
#

usage() {
	echo
	echo "Usage:"
	echo " ${0##*/} [-p <PROJECT NAME>] [-s <STATE>] [-v] [-h]"
	echo
	echo "Options:"
	echo " -p: default current project"
	echo " -s: filt merge request, [all, opened, closed, locked, merged], default opened"
	echo " -v: show version"
	echo " -h: show help"
	echo
	echo "Example 1:"
	echo " ${0##*/} -p bell/owl-ios -s all"
	echo "Example 2:"
	echo " ${0##*/}"
	echo
}

checkAccessToken() {
	if [[ ! -n ${GITLAB_ACCESS_TOKEN} ]]; then
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

version=0.0.5
while getopts 'p:s:vh' arg; do
	case $arg in
	p) gitlab_project_name=$OPTARG ;;
	s) state=$OPTARG ;;
	v) echo ${version} && exit 0 ;;
	h) usage && exit 0 ;;
	?) usage && exit 1 ;;
	esac
done

if [[ -z ${state} ]]; then
	state="opened"
fi

if [[ -z ${GITLAB_API_ADDRESS} ]]; then
	GITLAB_API_ADDRESS="https://gitlab.com/api/v4"
fi

if [[ -z ${gitlab_project_name} ]]; then
	gitlab_project_name=$(git config --local remote.origin.url) || exit 1
	gitlab_project_name=${gitlab_project_name##*:}
	gitlab_project_name=${gitlab_project_name%.*}
fi

checkAccessToken
checkShellEnv

# test gitlab api address
echo curl -sSf ${GITLAB_API_ADDRESS}/projects >/dev/null || exit 1

project_id=$(urlencode $gitlab_project_name)
# list merge request
# @ref https://github.com/gitlabhq/gitlabhq/blob/master/doc/api/merge_requests.md#list-project-merge-requests
merge_requests=$(curl --silent --header "PRIVATE-TOKEN: ${GITLAB_ACCESS_TOKEN}" \
	"${GITLAB_API_ADDRESS}/projects/${project_id}/merge_requests?state=${state}")
echo ${merge_requests} | jq '.[] | {title: .title, address: .web_url}'