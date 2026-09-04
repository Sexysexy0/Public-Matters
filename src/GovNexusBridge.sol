// SPDX-License-Identifier: WIZARD-GENESIS-V1
pragma solidity ^0.8.0;

/*
========================================================
[ SAUCE EXPLANATION ]
Contract: GovNexusBridge (#51)
Purpose: The official API bridge to the Philippine eGov PH system.
- Allows DICT and government agencies to query the Nexus 
  without needing admin access.
- Verifies land titles (LandTrustDAO), citizen identities (NexusID), 
  and infrastructure audits (InfrastructureTransparencyDAO) in a read-only capacity.
- Reduces corruption by letting the government "pull" data from the immutable 
  ledger, rather than "pushing" data into a vulnerable central database.
========================================================
*/
contract GovNexusBridge {
    address public admin;
    
    // Pointers to key Nexus contracts
    address public landTrust;
    address public nexusID;
    address public infraDAO;

    constructor(address _landTrust, address _nexusID, address _infraDAO) {
        admin = msg.sender;
        landTrust = _landTrust;
        nexusID = _nexusID;
        infraDAO = _infraDAO;
    }

    // 1. Verify a citizen's digital identity
    function verifyCitizen(address _wallet) public view returns (bool) {
        (bool success, bytes memory data) = address(nexusID).staticcall(
            abi.encodeWithSignature("isVerified(address)", _wallet)
        );
        if (success) return abi.decode(data, (bool));
        return false;
    }

    // 2. Verify who owns a specific Plot ID
    function verifyLandOwnership(uint256 _plotId) public view returns (address) {
        (bool success, bytes memory data) = address(landTrust).staticcall(
            abi.encodeWithSignature("landDeedNFT(uint256)", _plotId)
        );
        if (success) return abi.decode(data, (address));
        return address(0);
    }

    // 3. Get the total spent on a specific infrastructure project
    function getInfraSpent(uint256 _projectId) public view returns (uint256) {
        (bool success, bytes memory data) = address(infraDAO).staticcall(
            abi.encodeWithSignature("getProjectDetails(uint256)", _projectId)
        );
        if (success) {
            // Decode the complex tuple to extract the "spent" field (2nd field)
            (string memory name, string memory loc, uint256 budget, uint256 spent, bool active) = abi.decode(data, (string, string, uint256, uint256, bool));
            return spent;
        }
        return 0;
    }
    receive() external payable {}
}
