// SPDX-License-Identifier: Scrollchain-Ratification
pragma solidity ^0.8.19;

contract TreatyRatificationPing {
    address public steward;
    mapping(string => bool) public ratifiedTreaties;

    event TreatyPinged(string treaty, string timestamp);
    event TreatyRatified(string treaty, string timestamp);

    constructor() {
        steward = msg.sender;
    }

    function pingTreaty(string memory treaty, string memory timestamp) public {
        require(msg.sender == steward, "Unauthorized steward");
        emit TreatyPinged(treaty, timestamp);
    }

    function ratifyTreaty(string memory treaty, string memory timestamp) public {
        require(msg.sender == steward, "Unauthorized steward");
        ratifiedTreaties[treaty] = true;
        emit TreatyRatified(treaty, timestamp);
    }

    function isRatified(string memory treaty) public view returns (bool) {
        return ratifiedTreaties[treaty];
    }
}
