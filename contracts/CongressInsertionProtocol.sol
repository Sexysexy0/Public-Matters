pragma solidity ^0.8.20;

contract CongressInsertionProtocol {
    address public admin;

    struct Insertion {
        string proponent;    // e.g. senator, partylist, district rep
        string project;      // e.g. flood control, streetlights
        uint256 amount;      // e.g. 300000000
        uint256 timestamp;
    }

    Insertion[] public insertions;

    event InsertionLogged(string proponent, string project, uint256 amount, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logInsertion(string calldata proponent, string calldata project, uint256 amount) external onlyAdmin {
        insertions.push(Insertion(proponent, project, amount, block.timestamp));
        emit InsertionLogged(proponent, project, amount, block.timestamp);
    }

    function totalInsertions() external view returns (uint256) {
        return insertions.length;
    }
}
