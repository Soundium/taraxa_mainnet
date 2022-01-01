#!/bin/bash
# wget -q -O taraxa.sh https://github.com/Soundium/taraxa_mainnet/taraxa_mainnet.sh && chmod +x taraxa_mainnet.sh && sudo /bin/bash taraxa_mainnet.sh


exists()
{
  command -v "$1" >/dev/null 2>&1
}
if exists curl; then
	echo ''
else
  sudo apt install curl -y < "/dev/null"
fi
bash_profile=$HOME/.bash_profile
if [ -f "$bash_profile" ]; then
    . $HOME/.bash_profile

function setupVars {
	echo 'TARAXA_NODE_PATH=/var/taraxa' >> $HOME/.bash_profile
	. $HOME/.bash_profile
	sleep 1
}

function setupSwap {
	echo -e '\n\e[42mSet up swapfile\e[0m\n'
	curl -s https://github.com/Soundium/taraxa_mainnet/swap4.sh | bash
}

function installDocker {
	wget -O get-docker.sh https://get.docker.com 
	sudo sh get-docker.sh
	# sudo apt install -y docker-compose docker.io < "/dev/null"
	# sudo apt install -y docker-compose < "/dev/null"
	wget https://github.com/docker/compose/releases/download/1.29.2/docker-compose-Linux-x86_64
	chmod +x docker-compose-Linux-x86_64
	mv docker-compose-Linux-x86_64 /usr/bin/docker-compose
	rm -f get-docker.sh
}

function installDeps {
	echo -e '\n\e[42mPreparing to install\e[0m\n' && sleep 1
	cd $HOME
	sudo apt update
	sudo apt install wget curl unzip -y < "/dev/null"
	if exists docker; then
		echo -e '\n\e[42mDocker already installed\e[0m\n' && sleep 1
	else
		installDocker
	fi
}

function installSoftware {
	echo -e '\n\e[42mInstall software\e[0m\n' && sleep 1
	cd $HOME
        mkdir -p mainnet/config
	cd $HOME/mainnet
        wget https://raw.githubusercontent.com/Taraxa-project/taraxa-ops/master/taraxa_compose_mainnet/docker-compose.yml
	echo -e '\n\e[42mRunning\e[0m\n' && sleep 1
	sudo docker-compose pull
	sudo docker-compose up -d --force-recreate
}

function checkStatus {
echo -e '\n\e[42mCheck node status\e[0m\n' && sleep 1
if [[ `docker ps --filter status=running --format "{{.Names}}" | grep mainnet_node_1` =~ "mainnet_node_1" ]]; then
  echo -e "Your Taraxa node \e[32minstalled and works\e[39m!"
  echo -e "You can check node status by the command \e[7mdocker ps\e[0m"
  echo -e "You can check node logs by the command \e[7mcd $HOME/mainnet && docker-compose logs -f --tail=50\e[0m"
  echo -e "Your node address:"
  echo -e "\e[7m""0x"$(docker exec mainnet_node_1 cat /opt/taraxa_data/conf/wallet.json | jq .node_address | sed 's/"//g')"\e[0m"
  echo -e "Your node proof:"
  echo -e "\e[7m"$(docker exec mainnet_node_1 taraxa-sign sign --wallet /opt/taraxa_data/conf/wallet.json)"\e[0m"
else
  echo -e "Your Taraxa node \e[31mwas not installed correctly\e[39m, please reinstall."
fi
. $HOME/.bash_profile
}

function deleteTaraxa {
	cd $HOME/mainnet
	docker-compose down
	cd $HOME
}

PS3='Please enter your choice (input your option number and press enter): '
options=("Install" "Upgrade (reinstall)" "Delete" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Install")
            echo -e '\n\e[42mYou choose install...\e[0m\n' && sleep 1
			setupVars
			setupSwap
			installDeps
			installSoftware
			checkStatus
			break
            ;;
        "Upgrade (reinstall)")
            echo -e '\n\e[33mYou choose upgrade (reinstall)...\e[0m\n' && sleep 1
			installSoftware
			checkStatus
			echo -e '\n\e[33mYour node was upgraded (reinstalled)!\e[0m\n' && sleep 1
			break
            ;;
		"Delete")
            echo -e '\n\e[31mYou choose delete...\e[0m\n' && sleep 1
			deleteTaraxa
			echo -e '\n\e[42mTaraxa was deleted!\e[0m\n' && sleep 1
			break
            ;;
        "Quit")
            break
            ;;
        *) echo -e "\e[91minvalid option $REPLY\e[0m";;
    esac
done
