# Git Merge Request

Create and list gitlab merge request

## Install

```shell
curl -fsSL "https://github.com/greedbell/git-merge-request/raw/master/git-merge-request-install.sh" | /bin/sh
```

This command will install `gmrl` to list gitlab merge request, and `gmrc` to create gitlab merge request.

## Usage

### Set Environment

#### GITLAB_API_ADDRESS

the API address of gitlab. Default `https://gitlab.com/api/v4`.

custom GITLAB_API_ADDRESS

```sh
echo "export GITLAB_API_ADDRESS=\"Your Gitlab Api Address\"" >> ~/.bash_profile
source ~/.bash_profile
```

#### GITLAB_ACCESS_TOKEN

You must add environment variable GITLAB_ACCESS_TOKEN first，it is used to posting request to gitlab.

first got to `Gitlab > Settings > Access Tokens` to generate Access Token, attention, the `scopes` must contain `api`.

then set the token to environment
```sh
echo "export GITLAB_ACCESS_TOKEN=\"Your Gitlab Access Token\"" >> ~/.bash_profile
source ~/.bash_profile
```

### Create Merge Request

Create Merge Request

```
$ gmrc -h

Usage:
 gmrc [-p <PROJECT Name>] [-s <SOURCE BRANCH>] [-t <TARGET BRANCH>] [-m <TITLE>] [-d <DISABLE AUTO PUSH>] [-v] [-h]

Options:
 -p: default current project
 -s: default current branch
 -t: default master branch
 -m: default latest commit
 -d: default auto push current branch to origin branch, if set disable auto push
 -v: show version
 -h: show help

Example 1:
 gmrc -p bell/owl-ios -s test -t master -m title -d
Example 2
 gmrc
```

### List Merge Request

List Merge Request

```
$ gmrl -h

Usage:
 gmrl [-p <PROJECT NAME>] [-s <STATE>] [-v] [-h]

Options:
 -p: default current project
 -s: filt merge request, [all, opened, closed, locked, merged], default opened
 -v: show version
 -h: show help

Example 1:
 gmrl -p bell/owl-ios -s all
Example 2:
 gmrl
```

### Update Merge Request

Directly use `git push origin <BRANCH>`
