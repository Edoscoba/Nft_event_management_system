// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";


contract EventSystem {
    address public nftContractAddress;
    uint256 public eventCount;

    struct Event {
        uint256 id;
        string name;
        string description;
        uint256 duration;
        uint256 dateCreated;
        bool isRegistered;
    }

    struct Users {
        string name;
        string email;
    }

    // mapping (uint256 id => mapping (address => bool)) registeredUsers;
    mapping (uint256 => Event) eventCreated;
    mapping (address => Event[]) events;
    mapping (address => bool) hasRegistered;
    mapping (address => Users) users;

    event EventCreatedSuccessfully(uint256 indexed id, string indexed name);
    event UserRegistrationSuccessful(string indexed name, string indexed email);

    constructor(address _nftContractAddress) {
        nftContractAddress = _nftContractAddress;
    } 

    function createEvent(uint256 _duration, string memory _name, string memory _description) external {
        require(msg.sender != address(0), "Address zero detected");

        IERC721 _nftContract = IERC721(nftContractAddress);
        require(_nftContract.balanceOf(msg.sender) > 0, "You must own an NFT to proceed");

        uint256 _id = eventCount++;
        uint256 date = block.timestamp;

        Event storage evnt = eventCreated[_id];

        evnt.id = _id;
        evnt.name = _name;
        evnt.description = _description;
        evnt.duration = _duration;
        evnt.dateCreated = date;

        evntCount += 1;

        events[msg.sender].push(evnt);

        emit EventCreatedSuccessfully(_id, _name);

    }

    function registerForEvent(uint256 _id, string memory _name, string memory _email) external {
        require(msg.sender != address(0), "Address zero detected");

        Event storage evnt = eventCreated[_id];
        require(evnt.id != 0, "invalid event id");
        require(!evnt.isRegistered, "already registered for event");

        uint256 _duration = evnt.dateCreated + evnt.duration;
        require(block.timestamp < _duration, "Event registration ended");

        users[msg.sender] = Users( _name, _email);
        hasRegistered[msg.sender] = true;
        evnt.isRegistered = true;

        emit UserRegistrationSuccessful(_name, _email);
    }

    
}
