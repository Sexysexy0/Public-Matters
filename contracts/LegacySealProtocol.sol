pragma solidity ^0.8.20;

contract LegacySealProtocol {
    address public admin;

    struct Legacy {
        string leader;       // e.g. transitional leader, communal steward
        string action;       // e.g. reform, liberation, rebuild
        uint256 timestamp;
    }

    Legacy[] public legacies;

    event LegacyLogged(string leader, string action, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logLegacy(string calldata leader, string calldata action) external onlyAdmin {
        legacies.push(Legacy(leader, action, block.timestamp));
        emit LegacyLogged(leader, action, block.timestamp);
    }

    function totalLegacies() external view returns (uint256) {
        return legacies.length;
    }
}
