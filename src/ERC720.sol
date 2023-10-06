// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyPersonalNFT is ERC721, ERC721Enumerable, ERC721Pausable, Ownable {
    uint256 private _nextTokenId;
    uint256 constant MAX_SUPPLY = 1000;
    uint256 constant ALLOWLIST_MAX_SUPPLY = 100;
    bool public publicMintOpen = false;
    bool public allowListMintOpen = false;
    mapping(address => bool) public allowList;

    constructor(address initialOwner)
    ERC721("MyPersonalNFT", "MPN")
    Ownable(initialOwner)
    {}

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://Qmaa6TuP2s9pSKczHF4rwWhTKUdygrrDs8RmYYqCjP3Hye/";
    }

    function setAllowlist(address[] calldata addresses) external onlyOwner {
        for (uint256 i = 0; i < addresses.length; i++) {
            allowList[addresses[i]] = true;
        }
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    // Toggle mint
    function toggleMint(bool _publicMintOpen, bool _allowListMintOpen) external onlyOwner {
        publicMintOpen = _publicMintOpen;
        allowListMintOpen = _allowListMintOpen;
    }

    // Public mint
    function publicMint() public payable {
        require(publicMintOpen, "Public Mint is Closed");
        require(msg.value == 0.01 ether, "not enough funds");
        require(totalSupply() <= MAX_SUPPLY, "We sold out!");
        uint256 tokenId = _nextTokenId++;
        _safeMint(msg.sender, tokenId);
    }

    // Only allowList wallets can mint in this phase
    function allowlistMint() public payable {
        require(allowListMintOpen, "Allowlist Mint is Closed");
        require(msg.value == 0.001 ether, "not enough funds");
        require(allowList[msg.sender], "You are not on the allowlist!"); // check if user is allowlisted or nah
        require(totalSupply() <= ALLOWLIST_MAX_SUPPLY, "Allowlist is sold out! Wait for Public Mint ;)");
        uint256 tokenId = _nextTokenId++;
        _safeMint(msg.sender, tokenId);
    }

    // The following functions are overrides required by Solidity.

    function _update(address to, uint256 tokenId, address auth)
    internal
    override(ERC721, ERC721Enumerable, ERC721Pausable)
    returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(address account, uint128 value)
    internal
    override(ERC721, ERC721Enumerable)
    {
        super._increaseBalance(account, value);
    }

    function supportsInterface(bytes4 interfaceId)
    public
    view
    override(ERC721, ERC721Enumerable)
    returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function withdraw(address _addr) external onlyOwner {
        // get the balance of this contract
        uint256 balance = address(this).balance;
        payable(_addr).transfer(balance);
    }
}