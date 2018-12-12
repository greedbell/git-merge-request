# Git Merge Request

Create and list gitlab merge request

## Installation

```shell
curl -fsSL "https://raw.githubusercontent.com/greedbell/git-merge-request/master/git-merge-request-install.sh" | /bin/sh
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
 gmrc [-p <PROJECT NAME>] [-s <SOURCE BRANCH>] [-t <TARGET BRANCH>] [-m <TITLE>] [-d <DISABLE AUTO PUSH>] [-v] [-u] [-h]

Options:
 -p: target project, default current project
 -s: source branch, default current branch
 -t: target branch, default master
 -m: merge request title, default latest commit
 -d: whether disable auto push to remote branch, default true, if false disable
 -v: show version
 -u: check update
 -h: show help

Example 1:
 gmrc -p greedbell/git-merge-request -s test -t master -m title -d
Example 2
 gmrc
```

### List Merge Request

List Merge Request

```
$ gmrl -h

Usage:
 gmrl [-p <PROJECT NAME>] [-s <STATE>] [-v] [-u] [-h]

Options:
 -p: target project, default current project
 -s: filt merge request, must be on of [all, opened, closed, locked, merged], default opened
 -v: show version
 -u: check update
 -h: show help

Example 1:
 gmrl -p greedbell/git-merge-request -s all
Example 2:
 gmrl
```

### Update Merge Request

Directly use `git push origin <BRANCH>`
