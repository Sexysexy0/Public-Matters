// UnstoppableCreatorVault.sol
pragma solidity ^0.8.0;

contract UnstoppableCreatorVault {
    struct Content {
        string title;
        string contentCID; // IPFS hash
        uint256 timestamp;
    }

    mapping(address => Content[]) public creatorLibrary;

    function publishPermanentContent(string memory _title, string memory _cid) public {
        // Content exists as long as the internet exists
        // No central server, no "Delete" button for the elites
        creatorLibrary[msg.sender].push(Content(_title, _cid, block.timestamp));
    }
}
