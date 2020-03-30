#!/bin/sh
default_branch="${2}"
# default_head_sha1="$(git rev-parse "${default_branch}")"
merged_branch="${3}"
repository_url="${1}"
git clone "${repository_url}" .
git branch -a | \
    grep remotes/origin | \
    sed -Ee 's;([* ]|remotes/origin);;' | \
    while read -r branch ; \
    do \
        if [ "${branch}" = "${default_branch}" ] || [ "${branch}" = "${merged_branch}" ] ; \
        then \
            continue ; \
        fi ; \
        git checkout "${branch}" ; \
        git rebase origin/master ; \
        [ -z "${CI}" ] && git push --force-with-lease origin "${branch}:${branch}" ; \
    done
