pragma solidity ^0.8.20;

contract WaterSecurityProtocol {
    address public admin;

    struct Water {
        string source;       // e.g. rivers, aquifers
        string threat;       // e.g. mining contamination
        string consequence;  // e.g. loss of drinking water, farm irrigation
        uint256 timestamp;
    }

    Water[] public waters;

    event WaterLogged(string source, string threat, string consequence, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logWater(string calldata source, string calldata threat, string calldata consequence) external onlyAdmin {
        waters.push(Water(source, threat, consequence, block.timestamp));
        emit WaterLogged(source, threat, consequence, block.timestamp);
    }

    function totalWaters() external view returns (uint256) {
        return waters.length;
    }
}
