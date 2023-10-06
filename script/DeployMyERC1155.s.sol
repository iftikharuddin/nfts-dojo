// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MyERC1155} from "../src/MyERC1155.sol";

contract DeployMyERC1155 is Script {

    function run() external returns (MyERC1155) {
        // Declare and initialize the arrays
        address[] memory _payees = new address[](2);
        uint256[] memory _shares = new uint256[](2);

        // Add values to the arrays
        _payees[0] = 0x73de83588F8D99d8043143b29BCD015A61433A29; // wallet 10 percent shares
        _payees[1] = 0x497A6c8CfC6A3C565284685a2a3C66aED7444BdF; // wallet 90 percent shares

        // NOTE: Deployer/Owner wallet will be the one which is set in .env

        _shares[0] = 10; // 10 percent shares
        _shares[1] = 90; // 90 percent shares

        vm.startBroadcast();
        MyERC1155 myERC1155 = new MyERC1155(_payees, _shares);
        vm.stopBroadcast();
        return myERC1155;
    }
}
