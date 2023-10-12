#!/bin/bash

#install Vagrant and VirtualBox
install_vagrant_virtualbox() {
    echo "Installing Vagrant and VirtualBox..."
    wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    apt update && apt install vagrant virtualbox -y
}

#add Vagrant box and download Vagrantfile
setup_vagrant() {
    echo "Adding Vagrant box and creating Vagrantfile..."
    vagrant box add ubuntu/focal64
    wget -O vagrantfile https://raw.githubusercontent.com/iamahmadpk/Vagrant/main/vagrantfile
}

# Create Vm
create_vm(){
    sudo vagrant up
}
#install Docker
install_docker() {
    echo "Installing Docker"
    # Install Docker on master
    vagrant ssh master -c "sudo apt update && sudo apt install docker.io -y"
    
    # Install Docker on slaves
    for i in {1..2}; do
        vagrant ssh "slave$i" -c "sudo apt update && sudo apt install docker.io -y"
    done
}
pullImage(){
    vagrant ssh master -c "sudo docker pull kasmweb/ubuntu-focal-desktop:1.13.0"
    echo vagrant ssh master -c "sudo docker pull kasmweb/ubuntu-focal-desktop:1.13.0" 
}
# setting up Docker Swarm
setup_docker_swarm() {
    echo "Docker Swarm..."
    #Docker Swarm master
    vagrant ssh master -c "sudo docker swarm init --advertise-addr 192.168.56.10" 
    #echo vagrant ssh master -c "sudo docker swarm init --advertise-addr 192.168.56.10" 
    # Get token for workers to join the swarm
  
    join_command=$(vagrant ssh master -c "sudo docker swarm join-token worker | grep 'docker swarm join' | sed 's/^[[:space:]]*//'")
    command=$(echo "sudo $join_command")
    echo "$command"
    #echo "$command" > command.txt
    #sleep 30
    #join_token=$(vagrant ssh master -c "sudo docker swarm join-token worker -q | sed 's/^[[:space:]]*//'")
    #echo "Token: $join_token"
    #printf "sudo docker swarm join --token $join_token 192.168.56.10:2377"
    #printf "sudo docker swarm join --token %s 192.168.56.10:2377" "$join_token"
   

    for i in {1..2}; do
        #vagrant ssh slave$i -c "sudo docker swarm join --token SWMTKN-1-4inwsor2rqia6rxkvlbovbfo18nj5xbwiklcupcf4v5ke9hula-e0wsaie314v23iu16c07bpldh 192.168.56.10:2377"
        vagrant ssh slave$i -c "$command"
       
        #echo vagrant ssh slave$i -c "$command"
    #sleep 30
    done
}

#Docker stack
deploy_docker_stack() {
    echo "Deploying Docker stack..."
    vagrant ssh master -c "wget -O docker-compose.yml https://raw.githubusercontent.com/iamahmadpk/Vagrant/main/docker-compose.yml && sudo docker stack deploy -c docker-compose.yml DevOpsWorkSpace"
}

#Function Call
install_vagrant_virtualbox
setup_vagrant
create_vm
install_docker
pullImage
setup_docker_swarm
deploy_docker_stack


