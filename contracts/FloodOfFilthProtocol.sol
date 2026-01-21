pragma solidity ^0.8.20;

contract FloodOfFilthProtocol {
    address public admin;

    struct Corruption {
        string medium;       // e.g. TV, movies, sex education
        string content;      // e.g. explicit material, occult glorification
        uint256 timestamp;
    }

    Corruption[] public corruptions;

    event CorruptionLogged(string medium, string content, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logCorruption(string calldata medium, string calldata content) external onlyAdmin {
        corruptions.push(Corruption(medium, content, block.timestamp));
        emit CorruptionLogged(medium, content, block.timestamp);
    }

    function totalCorruptions() external view returns (uint256) {
        return corruptions.length;
    }
}
