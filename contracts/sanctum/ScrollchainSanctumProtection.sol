// SPDX-License-Identifier: Mythic-License-1.0
pragma solidity ^0.8.19;

contract ScrollchainSanctumProtection {
    address public steward;
    struct Sanctum {
        string location;
        bool consentObtained;
        bool evictionProtected;
        uint256 compensationOffered;
    }

    mapping(address => Sanctum) public sanctums;

    event SanctumRegistered(address indexed resident, string location);
    event ProtectionUpdated(address indexed resident, bool evictionProtected);
    event CompensationLogged(address indexed resident, uint256 amount);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function registerSanctum(address resident, string memory location, bool consent) public onlySteward {
        sanctums[resident] = Sanctum(location, consent, false, 0);
        emit SanctumRegistered(resident, location);
    }

    function updateEvictionProtection(address resident, bool status) public onlySteward {
        sanctums[resident].evictionProtected = status;
        emit ProtectionUpdated(resident, status);
    }

    function logCompensation(address resident, uint256 amount) public onlySteward {
        sanctums[resident].compensationOffered = amount;
        emit CompensationLogged(resident, amount);
    }

    function getSanctumDetails(address resident) public view returns (Sanctum memory) {
        return sanctums[resident];
    }
}
