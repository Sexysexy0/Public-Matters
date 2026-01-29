pragma solidity ^0.8.20;

contract LegacyFulfillmentProtocol {
    address public admin;

    struct Legacy {
        string family;       // e.g. "Spouse + 2 children"
        string asset;        // e.g. Ayala property
        string vision;       // e.g. Happy living, validator-grade fulfillment
        uint256 timestamp;
    }

    Legacy[] public legacies;

    event LegacyLogged(string family, string asset, string vision, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logLegacy(string calldata family, string calldata asset, string calldata vision) external onlyAdmin {
        legacies.push(Legacy(family, asset, vision, block.timestamp));
        emit LegacyLogged(family, asset, vision, block.timestamp);
    }

    function totalLegacies() external view returns (uint256) {
        return legacies.length;
    }
}
