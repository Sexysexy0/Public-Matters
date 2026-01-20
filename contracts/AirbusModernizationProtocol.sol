pragma solidity ^0.8.20;

contract AirbusModernizationProtocol {
    address public admin;

    struct Modernization {
        string aircraft;     // e.g. Airbus A350-1000
        string benefit;      // e.g. fuel efficiency, passenger comfort, sustainability
        uint256 timestamp;
    }

    Modernization[] public modernizations;

    event ModernizationLogged(string aircraft, string benefit, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logModernization(string calldata aircraft, string calldata benefit) external onlyAdmin {
        modernizations.push(Modernization(aircraft, benefit, block.timestamp));
        emit ModernizationLogged(aircraft, benefit, block.timestamp);
    }

    function totalModernizations() external view returns (uint256) {
        return modernizations.length;
    }
}
