// contracts/UnionResilience.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title UnionResilience
 * @notice Logs union activities and resilience measures.
 */
contract UnionResilience {
    address public admin;

    struct Union {
        string name;
        uint256 members;
        string status;   // "Active", "Suppressed"
        uint256 timestamp;
    }

    Union[] public unions;

    event UnionLogged(string name, uint256 members, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logUnion(string calldata name, uint256 members, string calldata status) external onlyAdmin {
        unions.push(Union(name, members, status, block.timestamp));
        emit UnionLogged(name, members, status, block.timestamp);
    }

    function totalUnions() external view returns (uint256) { return unions.length; }

    function getUnion(uint256 id) external view returns (Union memory) {
        require(id < unions.length, "Invalid id");
        return unions[id];
    }
}
