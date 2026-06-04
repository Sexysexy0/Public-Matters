// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title DynastyReform
/// @notice Covenant contract to encode safeguards against political dynasties
contract DynastyReform {
    address public owner;

    struct Reform {
        string dynastyName;   // e.g. "Family X", "Clan Y"
        string safeguard;     // covenant safeguard action
        uint256 timestamp;
    }

    Reform[] public reforms;

    event ReformLogged(string dynastyName, string safeguard, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function logReform(string memory dynastyName, string memory safeguard) public onlyOwner {
        Reform memory newReform = Reform(dynastyName, safeguard, block.timestamp);
        reforms.push(newReform);
        emit ReformLogged(dynastyName, safeguard, block.timestamp);
    }

    function getReform(uint256 index) public view returns (string memory, string memory, uint256) {
        Reform memory r = reforms[index];
        return (r.dynastyName, r.safeguard, r.timestamp);
    }

    function getReformCount() public view returns (uint256) {
        return reforms.length;
    }
}
