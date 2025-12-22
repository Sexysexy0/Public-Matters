// contracts/CommunitySafeSpace.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title CommunitySafeSpace
 * @notice Protocol for communal safe spaces like public markets, parks, and plazas.
 */
contract CommunitySafeSpace {
    address public admin;

    struct Space {
        string name;
        string type;       // "Market", "Park", "Plaza"
        string status;     // "Protected", "Threatened"
        uint256 timestamp;
    }

    Space[] public spaces;

    event SpaceLogged(string name, string type, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logSpace(string calldata name, string calldata type, string calldata status) external onlyAdmin {
        spaces.push(Space(name, type, status, block.timestamp));
        emit SpaceLogged(name, type, status, block.timestamp);
    }

    function totalSpaces() external view returns (uint256) { return spaces.length; }

    function getSpace(uint256 id) external view returns (Space memory) {
        require(id < spaces.length, "Invalid id");
        return spaces[id];
    }
}
