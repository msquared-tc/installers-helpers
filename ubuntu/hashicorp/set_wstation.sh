#!/bin/bash
# UBUNTU 20 :: MSquared TC

# variable defitions
hashisuite=(terraform consul waypoint nomad)

# function definitions
function install_hashi () {

    printf '===== SETTING HASHICORP REPOS =====\n'
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
    sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

    sudo apt-get -qqq update 

    for package in ${hashisuite[@]};
        do 
            printf "===== INSTALLING LATEST ${package} =====\n"
            sudo apt -qq install ${package} -y
        done
        
}

# main
install_hashi