# Taraxa Mainnet Script

One-line installation script is available:

# wget -q -O taraxa.sh https://github.com/Soundium/taraxa_mainnet/taraxa_mainnet.sh && chmod +x taraxa_mainnet.sh && sudo /bin/bash taraxa_mainnet.sh

Choose you wanted option (for example option 1 – simply installing the node) and wait for installation to complete.

To register your node you need to get its address, to do this execute the following command:

# docker exec taraxa_compose_node_1 cat /opt/taraxa_data/conf/wallet.json

Output should be like the following:

# b7669cc00f55b02ea66e0d944e904e8e9711b243

In that case, substitute 0x at the beginning of the line to get our node address:

# 0xb7669cc00f55b02ea66e0d944e904e8e9711b243

You also need to provide proof that this node is yours by running the following command:

# docker exec mainnet_node_1 taraxa-sign sign --wallet /opt/taraxa_data/conf/wallet.json

Per usual this name may be different in different environments, so to be sure you've got the right container name, just execute docker ps. 

Enter the result of the command in the Proof of node ownership input field.
To register your node, go to the community portal and register your node (In the case of the example, the address would be 0xb7669cc00f55b02ea66e0d944e904e8e9711b243)
