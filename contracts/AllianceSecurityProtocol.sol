pragma solidity ^0.8.20;

contract AllianceSecurityProtocol {
    address public admin;

    struct Security {
        string alliance;     // e.g. NATO
        string principle;    // e.g. collective defense, sovereignty
        string action;       // e.g. tariff response, Arctic partnership
        uint256 timestamp;
    }

    Security[] public securities;

    event SecurityLogged(string alliance, string principle, string action, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logSecurity(string calldata alliance, string calldata principle, string calldata action) external onlyAdmin {
        securities.push(Security(alliance, principle, action, block.timestamp));
        emit SecurityLogged(alliance, principle, action, block.timestamp);
    }

    function totalSecurities() external view returns (uint256) {
        return securities.length;
    }
}
