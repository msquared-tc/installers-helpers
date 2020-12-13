#!/bin/bash
# UBUNTU 20 :: MSquared TC

# variable defitions
hashisuite=(terraform consul waypoint nomad)
ubuntusuite=(vim git curl apt-transport-https ca-certificates gnupg-agent software-properties-common )

# function definitions
function install_ubuntu_pkgs () {

    printf "===== INSTALLING UBUNTU ITEMS ====="

    for package in ${ubuntusuite[@]};
        do 
            printf "===== INSTALLING ${package} =====\n"
            sudo apt -qq install ${package}
        done
}

function setup_repos () {

    printf '===== SETTING UP REPOS AND UPDATING =====\n'
    # hashicorp
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
    sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

    # docker
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
     $(lsb_release -cs) \
     stable"

    # update
    sudo apt-get update -qq -o=Dpkg::Use-Pty=0

}

function install_hashi () {

    for package in ${hashisuite[@]};
        do 
            printf "===== INSTALLING LATEST ${package} =====\n"
            sudo apt -qq install ${package} -y
        done

}

function install_microk8s () {

    printf "===== INSTALLING MICROK8S KUBERNETES =====\n"
    sudo snap install microk8s --classic

    printf "===== ENABLING BASIC SERVICES =====\n"
    sudo microk8s enable dashboard dns registry

    printf "===== STOPPING KUBERNETES =====\n"
    sudo microk8s stop

    printf "===== ADDING USER TO MICROK8S GROUP ====="
    sudo usermod -a -G microk8s ${USER}

}

function install_docker () {

    printf "===== INSTALLING DOCKER ====="
    #sudo apt-get remove docker docker-engine docker.io containerd runc
    sudo apt-get install docker-ce docker-ce-cli containerd.io


}

# main
install_ubuntu_pkgs
setup_repos
install_hashi
install_docker
install_microk8s