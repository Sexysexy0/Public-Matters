pragma solidity ^0.8.20;

contract EnvironmentalJusticeProtocol {
    address public admin;

    struct Justice {
        string threat;       // e.g. water, farms, ancestral land
        string action;       // e.g. protest, human barricade
        string consequence;  // e.g. arrests, silencing
        uint256 timestamp;
    }

    Justice[] public justices;

    event JusticeLogged(string threat, string action, string consequence, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logJustice(string calldata threat, string calldata action, string calldata consequence) external onlyAdmin {
        justices.push(Justice(threat, action, consequence, block.timestamp));
        emit JusticeLogged(threat, action, consequence, block.timestamp);
    }

    function totalJustices() external view returns (uint256) {
        return justices.length;
    }
}
