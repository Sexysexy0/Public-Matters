// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DiplomaticFrictionResolver {
    enum Nation { UnitedStates, India, Philippines, China, Japan, EU, ASEAN }
    enum FrictionType { Tariff, Sanction, ExportControl, VisaRestriction, DataAccess, Reputation }
    enum ResolutionStatus { Proposed, Active, Resolved, Rejected }

    struct FrictionCase {
        uint256 id;
        Nation partyA;
        Nation partyB;
        FrictionType frictionType;
        string issueDescription;
        string proposedResolution;
        ResolutionStatus status;
        string treatyClause;
        uint256 timestamp;
    }

    mapping(uint256 => FrictionCase) public frictionRegistry;
    uint256 public frictionCount;

    event FrictionLogged(uint256 id, Nation partyA, Nation partyB, FrictionType frictionType);
    event ResolutionActivated(uint256 id);
    event ResolutionFinalized(uint256 id);
    event ResolutionRejected(uint256 id);

    function logFriction(
        Nation partyA,
        Nation partyB,
        FrictionType frictionType,
        string memory issueDescription,
        string memory proposedResolution,
        string memory treatyClause,
        uint256 timestamp
    ) public {
        frictionRegistry[frictionCount] = FrictionCase(
            frictionCount,
            partyA,
            partyB,
            frictionType,
            issueDescription,
            proposedResolution,
            ResolutionStatus.Proposed,
            treatyClause,
            timestamp
        );
        emit FrictionLogged(frictionCount, partyA, partyB, frictionType);
        frictionCount++;
    }

    function activateResolution(uint256 id) public {
        require(id < frictionCount, "Invalid case ID");
        frictionRegistry[id].status = ResolutionStatus.Active;
        emit ResolutionActivated(id);
    }

    function finalizeResolution(uint256 id) public {
        require(id < frictionCount, "Invalid case ID");
        frictionRegistry[id].status = ResolutionStatus.Resolved;
        emit ResolutionFinalized(id);
    }

    function rejectResolution(uint256 id) public {
        require(id < frictionCount, "Invalid case ID");
        frictionRegistry[id].status = ResolutionStatus.Rejected;
        emit ResolutionRejected(id);
    }

    function getFrictionCase(uint256 id) public view returns (FrictionCase memory) {
        return frictionRegistry[id];
    }
}
