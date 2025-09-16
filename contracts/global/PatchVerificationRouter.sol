// SPDX-License-Identifier: PatchSanctum
pragma solidity ^0.8.19;

contract PatchVerificationRouter {
    struct PatchSignal {
        string cveID;
        string component;
        bool verified;
        string stewardNote;
    }

    mapping(string => PatchSignal) public patchRegistry;

    event PatchTagged(string cveID, string component);
    event PatchVerified(string cveID);

    function tagPatch(string memory cveID, string memory component, string memory stewardNote) public {
        patchRegistry[cveID] = PatchSignal(cveID, component, false, stewardNote);
        emit PatchTagged(cveID, component);
    }

    function verifyPatch(string memory cveID) public {
        require(bytes(patchRegistry[cveID].component).length > 0, "Patch not tagged");
        patchRegistry[cveID].verified = true;
        emit PatchVerified(cveID);
    }

    function getPatchStatus(string memory cveID) public view returns (PatchSignal memory) {
        return patchRegistry[cveID];
    }
}
