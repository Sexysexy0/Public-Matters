pragma solidity ^0.8.20;

contract MiddlePowerAllianceProtocol {
    address public admin;

    struct Alliance {
        string country;      // e.g. India, Canada, Brazil
        string principle;    // e.g. sovereignty, human rights
        string pragmatism;   // e.g. trade deal, multipolar engagement
        uint256 timestamp;
    }

    Alliance[] public alliances;

    event AllianceLogged(string country, string principle, string pragmatism, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logAlliance(string calldata country, string calldata principle, string calldata pragmatism) external onlyAdmin {
        alliances.push(Alliance(country, principle, pragmatism, block.timestamp));
        emit AllianceLogged(country, principle, pragmatism, block.timestamp);
    }

    function totalAlliances() external view returns (uint256) {
        return alliances.length;
    }
}
