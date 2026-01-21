pragma solidity ^0.8.20;

contract GlobalUnionProtocol {
    address public admin;

    struct Union {
        string participants; // e.g. ecumenical Protestants, Roman Catholic Church, political allies
        string purpose;      // e.g. power consolidation, spiritual facade, political influence
        uint256 timestamp;
    }

    Union[] public unions;

    event UnionLogged(string participants, string purpose, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logUnion(string calldata participants, string calldata purpose) external onlyAdmin {
        unions.push(Union(participants, purpose, block.timestamp));
        emit UnionLogged(participants, purpose, block.timestamp);
    }

    function totalUnions() external view returns (uint256) {
        return unions.length;
    }
}
