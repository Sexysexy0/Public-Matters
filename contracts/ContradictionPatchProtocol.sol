pragma solidity ^0.8.20;

contract ContradictionPatchProtocol {
    address public admin;

    struct Patch {
        string contradiction; // e.g. balance drop, ambiguous fee
        string explanation;   // e.g. unauthorized seizure, catastrophic collapse
        uint256 timestamp;
    }

    Patch[] public patches;

    event PatchLogged(string contradiction, string explanation, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logPatch(string calldata contradiction, string calldata explanation) external onlyAdmin {
        patches.push(Patch(contradiction, explanation, block.timestamp));
        emit PatchLogged(contradiction, explanation, block.timestamp);
    }

    function totalPatches() external view returns (uint256) {
        return patches.length;
    }
}
