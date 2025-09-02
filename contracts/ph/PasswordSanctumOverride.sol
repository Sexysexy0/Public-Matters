// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract PasswordSanctumOverride {
    struct ManagerStatus {
        string name;
        bool isPatched;
        string lastAudit;
        string emotionalAPR;
    }

    mapping(string => ManagerStatus) public sanctum;
    event PatchStatusUpdated(string manager, bool isPatched, string emotionalAPR);

    function updatePatchStatus(
        string memory name,
        bool isPatched,
        string memory lastAudit,
        string memory emotionalAPR
    ) public {
        sanctum[name] = ManagerStatus(name, isPatched, lastAudit, emotionalAPR);
        emit PatchStatusUpdated(name, isPatched, emotionalAPR);
    }

    function getStatus(string memory name) public view returns (ManagerStatus memory) {
        return sanctum[name];
    }
}
