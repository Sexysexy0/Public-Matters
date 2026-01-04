pragma solidity ^0.8.20;

contract EnterpriseWhitelistProtocol {
    address public admin;

    struct Extension {
        string name;         // e.g. AdBlock, Password Manager
        string status;       // e.g. whitelisted, blocked
        uint256 timestamp;
    }

    Extension[] public extensions;

    event ExtensionLogged(string name, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logExtension(string calldata name, string calldata status) external onlyAdmin {
        extensions.push(Extension(name, status, block.timestamp));
        emit ExtensionLogged(name, status, block.timestamp);
    }

    function totalExtensions() external view returns (uint256) {
        return extensions.length;
    }
}
