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

function install_microk8s () {

    printf "===== INSTALLING MICROK8S KUBERNETES =====\n"
    snap install microk8s --classic

    printf "===== ENABLING BASIC SERVICES =====\n"
    microk8s enable dashboard dns registry

    printf "===== STOPPING KUBERNETES =====\n"
    microk8s stop

}

# main
install_hashi
install_microk8s