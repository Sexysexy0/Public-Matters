pragma solidity ^0.8.20;

contract PatchManagementProtocol {
    address public admin;

    struct Patch {
        string system;       // e.g. Windows, Linux, Browser
        string status;       // e.g. applied, pending, failed
        uint256 timestamp;
    }

    Patch[] public patches;

    event PatchLogged(string system, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logPatch(string calldata system, string calldata status) external onlyAdmin {
        patches.push(Patch(system, status, block.timestamp));
        emit PatchLogged(system, status, block.timestamp);
    }

    function totalPatches() external view returns (uint256) {
        return patches.length;
    }
}
