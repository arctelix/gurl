#!/usr/bin/env bats



setup () {

    # make sure were in the correct directory!
    cd $BATS_TEST_DIRNAME

    # create git
    git init
}

teardown () {

    # remove gurl directory from clones
    [ -d "gurl" ] && rm -fr gurl

    # remove .git directory
    [ -d ".git" ] && rm -fr .git
}

# Test -u for all servers

@test "-u github" {

    result="$( gurl -u github user_name/repo_name )"
    [ "$result" = "https://github.com/user_name/repo_name" ]
    result="$( gurl -u gh user_name/repo_name )"
    [ "$result" = "https://github.com/user_name/repo_name" ]

}

@test "-u bitbucket" {

    result="$( gurl -u bitbucket user_name/repo_name )"
    [ "$result" = "https://user_name@bitbucket.org/user_name/repo_name" ]
    result="$( gurl -u bb user_name/repo_name )"
    [ "$result" = "https://user_name@bitbucket.org/user_name/repo_name" ]

}

@test "-u heroku" {

    result="$( gurl -u hr user_name/repo_name )"
    [ "$result" = "https://git.heroku.com/repo_name" ]
    result="$( gurl -u heroku user_name/repo_name )"
    [ "$result" = "https://git.heroku.com/repo_name" ]

}

# test -u variations

@test "-u test config user" {

    git config --local user.name git_user

    result="$( gurl -u gh repo_name )"
    [ "$result" = "https://github.com/git_user/repo_name" ]

}

@test "-u test incorrect server" {

    run gurl -u xx user_name/repo_name
    [ "$status" -eq 1 ]
    [ "${lines[0]}" = "$(echo "${lines[0]}" | grep 'gurl error')" ]

}

@test "-uq test url quiet mode" {

    run gurl -uq gh user_name/repo_name
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "https://github.com/user_name/repo_name" ]

    # with incorrect server

    run gurl -uq xx user_name/repo_name
    [ "$status" -eq 1 ]
    [ "${lines[0]}" = "" ]

}

@test "-ut test url test mode" {

    run gurl -ut gh user_name/repo_name
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "https://github.com/user_name/repo_name" ]

    # with incorrect server

    run gurl -ut xx user_name/repo_name
    [ "$status" -eq 1 ]
    [ "${lines[0]}" = "$(echo "${lines[0]}" | grep 'gurl error')" ]

}


# test clone

clone_repo="arctelix/gurl"
clone_param_cmd="clone -o gurl --depth 1"

@test "clone" {

    run gurl $clone_param_cmd gh $clone_repo
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "$(echo "${lines[0]}" | grep 'gurl success')" ]

}

@test "clone (-t)" {

    run gurl -t $clone_param_cmd gh $clone_repo
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "$(echo "${lines[0]}" | grep 'gurl success')" ]

}

@test "clone (-tq)" {

    run gurl -tq $clone_param_cmd gh $clone_repo
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "git $clone_param_cmd https://github.com/$clone_repo.git" ]

}


# test remote

remote_add_param_cmd="remote add -t master testremote"


@test "remote add" {

    run gurl $remote_add_param_cmd gh repo_name
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "$(echo "${lines[0]}" | grep 'gurl success')" ]



}

@test "remote add (-q )" {

    run gurl -q $remote_add_param_cmd gh repo_name
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "" ]

}

@test "remote add (-t)" {

    run gurl -t $remote_add_param_cmd gh user_name/repo_name
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "$(echo "${lines[0]}" | grep 'gurl success')" ]

    result="$( gurl -t $remote_add_param_cmd gh user_name/repo_name )"
    [ "$result" = "git $remote_add_param_cmd https://github.com/user_name/repo_name.git" ]

}

remote_set_url_param_cmd="remote set-url --push test"

@test "remote set-url" {

    git remote add test http://domain.com/change_me

    run gurl remote set-url test gh user_name/repo_name
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "$(echo "${lines[0]}" | grep 'gurl success')" ]

    # w/git param --push

    run gurl remote set-url --push test gh user_name/repo_name
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "$(echo "${lines[0]}" | grep 'gurl success')" ]

    # -q mode

    run gurl -q remote set-url --push test gh user_name/repo_name
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "" ]

    # -t mode

    result="$( gurl -t remote set-url --push test gh push/repo_name )"
    [ "$result" = "git remote set-url --push test https://github.com/push/repo_name.git" ]

}


@test "remote remove (-t)" {

    result="$( gurl -t remote remove test  )"
    [ "$result" = "git remote remove test" ]

}

@test "remote -v" {

    cmd="remote -v"
    result="$( gurl -t $cmd )"
    [ "$result" = "git $cmd" ]

}


# test other git commands tested with -t

@test "commit (-t)" {

    cmd="commit -am 'test commit'"
    result="$( gurl -t $cmd )"
    [ "$result" = "git $cmd" ]

}

@test "help (-t)" {

    cmd="help"
    result="$( gurl -t $cmd )"
    [ "$result" = "git $cmd" ]

}

@test "help repo (-t)" {

    cmd="help repo"
    result="$( gurl -t $cmd )"
    [ "$result" = "git $cmd" ]

}

@test "no args" {

    run gurl -t
    [ "$status" -eq 1 ]
    [ "${lines[0]}" = "" ]

}


@test "gurl alias: rs = remote show" {

    result="$( gurl -t rs )"
    [ "$result" = "git remote show" ]

}

@test "git alias: te = test" {

    git config --local alias.te test
    result="$( gurl -t te )"
    [ "$result" = "git test" ]

}

@test "GURL_ENDPOINTS" {

    GURL_ENDPOINTS=(
        'xx|long=https://xx.com/<user>/<repo>'
    )
    export GURL_ENDPOINTS

    # Export does not work in BATS so were simulating
    source ../gurl

    # test builting ok

    result="$( _gurl -u github user_name/repo_name )"
    [ "$result" = "https://github.com/user_name/repo_name" ]
    result="$( _gurl -u gh user_name/repo_name )"
    [ "$result" = "https://github.com/user_name/repo_name" ]

    # test custom xx

    result="$( _gurl -u long user_name/repo_name )"
    [ "$result" = "https://xx.com/user_name/repo_name" ]
    result="$( _gurl -u xx user_name/repo_name )"
    [ "$result" = "https://xx.com/user_name/repo_name" ]

}