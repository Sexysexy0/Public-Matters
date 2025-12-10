// contracts/AccessOrchestrator.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title AccessOrchestrator
 * @notice Coordinator contract to wire guardians, resilience domains, stories, and equity programs.
 */
contract AccessOrchestrator {
    address public admin;

    struct Link {
        string arcName;
        string reference;
        uint256 timestamp;
    }

    Link[] public links;

    event ArcLinked(string arcName, string reference, uint256 timestamp);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function linkArc(string calldata arcName, string calldata reference) external onlyAdmin {
        links.push(Link(arcName, reference, block.timestamp));
        emit ArcLinked(arcName, reference, block.timestamp);
    }

    function totalLinks() external view returns (uint256) {
        return links.length;
    }

    function getLink(uint256 id) external view returns (Link memory) {
        require(id < links.length, "Invalid id");
        return links[id];
    }
}
