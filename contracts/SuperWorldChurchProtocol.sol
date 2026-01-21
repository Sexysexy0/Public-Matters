pragma solidity ^0.8.20;

contract SuperWorldChurchProtocol {
    address public admin;

    struct Union {
        string participants; // e.g. liberal Protestants, Roman Catholic Church
        string practice;     // e.g. ordaining homosexual ministers, condoning occult
        uint256 timestamp;
    }

    Union[] public unions;

    event UnionLogged(string participants, string practice, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logUnion(string calldata participants, string calldata practice) external onlyAdmin {
        unions.push(Union(participants, practice, block.timestamp));
        emit UnionLogged(participants, practice, block.timestamp);
    }

    function totalUnions() external view returns (uint256) {
        return unions.length;
    }
}
