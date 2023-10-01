// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "../lib/foundry-devops/src/DevOpsTools.sol";
import {BasicNft} from "../src/BasicNft.sol";

contract MintBasicNft is Script {
    uint96 public constant FUND_AMOUNT = 3 ether;
    string public constant PUG_URI = "ipfs://QmZT57nEYVGVJDdF2WZeLLHuF6WRrzLw2R7U3vAxFkJHCq/?filename=PUG.json";

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("BasicNFT", block.chainid);
        mintNftOnContract(mostRecentlyDeployed);
    }

    function mintNftOnContract(address contractAddress) public {
        vm.startBroadcast();
        BasicNft(contractAddress).mintNFT(PUG_URI);
        vm.stopBroadcast();
    }
}
