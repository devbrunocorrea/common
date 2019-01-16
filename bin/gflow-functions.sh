#!/bin/bash

__gflow_helper_print_with_color()
{
  STARTCOLOR="\e[$2m";
  ENDCOLOR="\e[0m";

  printf "$STARTCOLOR%b$ENDCOLOR" "$1"
}

__gflow_helper_print_style() {
    if [ "$2" == "info" ] ; then
        COLOR="96";
    elif [ "$2" == "success" ] ; then
        COLOR="92";
    elif [ "$2" == "warning" ] ; then
        COLOR="93";
    elif [ "$2" == "danger" ] ; then
        COLOR="91";
    else
        COLOR="0";
    fi

    __gflow_helper_print_with_color "$1 \n" $COLOR
}

gflow-feature-start()
{
  git checkout develop;
  git checkout -b feature/${1};
  git status;
}

gflow-pull-develop() {
    CURRENT=`__gflow_helper_get_branch_name`;
    git checkout develop && \
    git pull --rebase origin develop && \
    git checkout ${CURRENT} && \
    git rebase develop && \
    __gflow_helper_print_style 'All commits from `develop` are here!' 'success';
}

gflow-push-develop() {
    gflow-push-to develop
}

gflow-sync() {
  gflow-pull-develop;
  gflow-push-develop;
}

gflow-push-to() {
    CURRENT=`__gflow_helper_get_branch_name`
    git checkout $1
    git merge ${CURRENT}
    git push origin $1
    git checkout ${CURRENT};
}

gflow-merge-to() {
    CURRENT=`git-branch-name`
    git checkout $1
    git merge --squash ${CURRENT}
}

gflow-squashing() {
    gflow-pull-develop;

    CURRENT=`__gflow_helper_get_branch_name`
    git checkout develop
    git merge --squash ${CURRENT}
    git commit;
    __gflow_helper_print_style 'Your code is on `develop`' 'success';
    NEWBRANCH="${CURRENT}i";
    git checkout -b ${NEWBRANCH};
    gflow-push-develop;
}

# Hack seguido de Ship
gflow-ship() {
    __gflow_helper_print_style 'Doing hack followed by ship' 'info';
    gflow-pull;
    gflow-push;
    __gflow_helper_print_style 'Done!' 'success';
}

# usage: gflow-absorb https://github.com/foo/common-schema feature-add-test-shipping
gflow-absorb() {
  CURRENT=`__gflow_helper_get_branch_name`
  TEMPORARY=tmp-$2
  git checkout -b $TEMPORARY
  git pull $1 $2;
  git checkout ${CURRENT}
  git merge --squash $TEMPORARY
}

gflow-squash-to-master() {
  CURRENT=`__gflow_helper_get_branch_name`
  git checkout -b "${CURRENT}-`date +"%m-%d-%y-%s"`";
  git checkout -b branchB
  git checkout master
  git checkout -b branchA
  git merge --no-edit -s ours branchB
  git branch branchTEMP
  git reset --hard branchB
  git reset --soft branchTEMP
  git commit --amend -m 'pack to master'
  git checkout master
  git merge --squash branchA
  git commit
  git branch -D  branchA branchB branchTEMP  ${CURRENT}
  git push origin master:master;
}

__gflow_helper_get_branch_name() {
  if [ -d .git ]; then
    git branch | grep '\*' | awk '{print $2}'
  fi;
}
