pragma solidity ^0.8.20;

contract ExtensionAuditProtocol {
    address public admin;

    struct Extension {
        string name;         // e.g. Chrome add-on, Firefox plugin
        string risk;         // e.g. high, medium, low
        string status;       // e.g. approved, flagged, removed
        uint256 timestamp;
    }

    Extension[] public extensions;

    event ExtensionLogged(string name, string risk, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logExtension(string calldata name, string calldata risk, string calldata status) external onlyAdmin {
        extensions.push(Extension(name, risk, status, block.timestamp));
        emit ExtensionLogged(name, risk, status, block.timestamp);
    }

    function totalExtensions() external view returns (uint256) {
        return extensions.length;
    }
}
