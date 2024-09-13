// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract EventSystem {
    address public nftContractAddress;
    uint256 public eventCount;

    struct Event {
        uint256 id;
        string name;
        string description;
        uint256 duration;
        uint256 dateCreated;
        bool isActive;
    }

    struct User {
        string name;
        string email;
    }

    mapping(uint256 => Event) public eventCreated;
    mapping(uint256 => address[]) public eventRegistrants;
    mapping(address => bool) public hasRegisteredForEvent;
    mapping(address => User) public users;

    event EventCreatedSuccessfully(uint256 indexed id, string indexed name);
    event UserRegistrationSuccessful(uint256 indexed eventId, string indexed name, string indexed email);

    constructor(address _nftContractAddress) {
        nftContractAddress = _nftContractAddress;
    }

    function createEvent(uint256 _duration, string memory _name, string memory _description) external {
        require(msg.sender != address(0), "Address zero detected");

        IERC721 nftContract = IERC721(nftContractAddress);
        require(nftContract.balanceOf(msg.sender) > 0, "You must own an NFT to proceed");

        uint256 eventId = eventCount++;
        uint256 dateCreated = block.timestamp;

        Event storage newEvent = eventCreated[eventId];

        newEvent.id = eventId;
        newEvent.name = _name;
        newEvent.description = _description;
        newEvent.duration = _duration;
        newEvent.dateCreated = dateCreated;
        newEvent.isActive = true;

        emit EventCreatedSuccessfully(eventId, _name);
    }

    function registerForEvent(uint256 _eventId, string memory _name, string memory _email) external {
        require(msg.sender != address(0), "Address zero detected");

        Event storage evnt = eventCreated[_eventId];
        require(evnt.id == _eventId, "Invalid event ID");
        require(evnt.isActive, "Event is not active");
        require(block.timestamp < evnt.dateCreated + evnt.duration, "Event registration ended");
        require(!hasRegisteredForEvent[msg.sender], "Already registered for event");

        users[msg.sender] = User(_name, _email);
        eventRegistrants[_eventId].push(msg.sender);
        hasRegisteredForEvent[msg.sender] = true;

        emit UserRegistrationSuccessful(_eventId, _name, _email);
    }

    function deactivateEvent(uint256 _eventId) external {
     
        Event storage evnt = eventCreated[_eventId];
        require(evnt.id == _eventId, "Invalid event ID");
        evnt.isActive = false;
    }
}
