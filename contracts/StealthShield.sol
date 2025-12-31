// contracts/StealthShield.sol
pragma solidity ^0.8.20;

contract StealthShield {
    address public admin;

    struct Shield {
        string type;        // "Cyber", "Diplomatic", "Economic"
        string description;
        uint256 timestamp;
    }

    Shield[] public shields;

    event ShieldLogged(string type, string description, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }
    constructor() { admin = msg.sender; }

    function logShield(string calldata type, string calldata description) external onlyAdmin {
        shields.push(Shield(type, description, block.timestamp));
        emit ShieldLogged(type, description, block.timestamp);
    }
}
