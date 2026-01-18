pragma solidity ^0.8.20;

contract CreditRatingMythProtocol {
    address public admin;

    struct Myth {
        string perception;   // e.g. investment grade = wealth
        string reality;      // e.g. creditworthiness ≠ prosperity
        uint256 timestamp;
    }

    Myth[] public myths;

    event MythLogged(string perception, string reality, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logMyth(string calldata perception, string calldata reality) external onlyAdmin {
        myths.push(Myth(perception, reality, block.timestamp));
        emit MythLogged(perception, reality, block.timestamp);
    }

    function totalMyths() external view returns (uint256) {
        return myths.length;
    }
}
