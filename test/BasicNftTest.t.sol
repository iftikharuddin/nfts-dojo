// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {BasicNft} from "../src/BasicNft.sol";
import {Test} from "forge-std/Test.sol";
import {DeployOurBasicNft} from "../script/DeployBasicNft.s.sol";


contract BasicNftTest is Test {

    BasicNft public basicNft;
    DeployOurBasicNft public deployer;
    address public USER = makeAddr("USER");

    string public constant PUG_URI = "ipfs://QmZT57nEYVGVJDdF2WZeLLHuF6WRrzLw2R7U3vAxFkJHCq/?filename=PUG.json";

    function setUp() public {
        deployer = new DeployOurBasicNft();
        basicNft = deployer.run();
    }

    function testNameIsCorrect() public view {
        string memory actualName = "Dogie";
        string memory expectedName = basicNft.name();
        // Compare the 'keccak256' hashes directly
        bool namesMatch = keccak256(abi.encodePacked(actualName)) == keccak256(abi.encodePacked(expectedName));
        assert(namesMatch);
    }

    function testCanMintAndHaveBalance() public  {
        vm.prank(USER);
        basicNft.mintNFT(PUG_URI);

        assert(basicNft.balanceOf(USER) == 1);
    }

    function testTokenURIIsCorrect() public {
        vm.prank(USER);
        basicNft.mintNFT(PUG_URI);

        assert(
            keccak256(abi.encodePacked(basicNft.tokenURI(0))) ==
            keccak256(abi.encodePacked(PUG_URI))
        );
    }


}