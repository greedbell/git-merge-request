#!/bin/bash
#Author: Bell<bell@greedlab.com>
#
# install git merge request tool
#

INSTALL_DIR=/usr/local/bin
gmrc_version=0.1.1
gmrl_version=0.1.1

# check env
if [[ ! -w ${INSTALL_DIR} ]]; then
	echo "You do not have write permission of ${INSTALL_DIR}, please run \"sudo chmod u+w ${INSTALL_DIR}\" to apply permission"
	exit 1
fi

checkPath=$(env | grep PATH | grep ${INSTALL_DIR})
if [[ -z ${checkPath} ]]; then
	echo "${INSTALL_DIR} is not in the PATH env, please add ${INSTALL_DIR} to the PATH env first"
	exit 1
fi

# install gmrc
installGmrc() {
  echo "Installing gmrc ..."
  echo
	curl https://raw.githubusercontent.com/greedbell/git-merge-request/${gmrc_version}/git-merge-request-create.sh --output ${INSTALL_DIR}/gmrc || exit 1
	chmod a+x ${INSTALL_DIR}/gmrc
  echo
	echo "gmrc ${gmrc_version} has been installed, run \"gmrc -h\" to show help"
	echo
}

hash gmrc >/dev/null 2>&1
if [[ $? -eq 0 ]]; then
	current_version=$(gmrc -v) || exit 1
	if [[ ${current_version} != ${gmrc_version} ]]; then
		installGmrc
	else
		echo "You have installed the latest gmrc!"
	fi
else
	installGmrc
fi

# install gmrl
installGmrl() {
  echo "Installing gmrl ..."
  echo
	curl https://raw.githubusercontent.com/greedbell/git-merge-request/${gmrl_version}/git-merge-request-list.sh --output ${INSTALL_DIR}/gmrl || exit 1
	chmod a+x ${INSTALL_DIR}/gmrl
  echo
	echo "gmrl ${gmrl_version} has been installed, run \"gmrl -h\" to show help"
	echo
}

hash gmrl >/dev/null 2>&1
if [ $? -eq 0 ]; then
	current_version=$(gmrl -v) || exit 1
	if [[ ${current_version} != ${gmrl_version} ]]; then
		installGmrl
	else
		echo "You have installed the latest gmrl!"
	fi
else
	installGmrl
fi
