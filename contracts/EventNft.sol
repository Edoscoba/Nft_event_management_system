// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract EventNFT is ERC721URIStorage, Ownable {
    uint256 private tokenID;

    constructor() ERC721("EDO NFT", "EDO") Ownable(msg.sender) {}


    function mintNFT(string memory _tokenURI) public onlyOwner returns (uint256) {

        uint256 _newItemId = tokenID++;

        _safeMint(msg.sender, _newItemId);
        _setTokenURI(_newItemId, _tokenURI);

        return _newItemId;
    }
}