// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FuelResilienceSupportContract {
    enum FacilityStatus { Operational, AtRisk, Shutdown }
    enum SupportType { Subsidy, EmergencyGrant, InfrastructureUpgrade }

    struct RefinerySupport {
        uint256 id;
        string facilityName;
        FacilityStatus status;
        SupportType supportType;
        uint256 allocatedFunds;
        string clauseReference;
        uint256 timestamp;
    }

    mapping(uint256 => RefinerySupport) public supportRegistry;
    uint256 public supportCount;

    event SupportLogged(uint256 id, string facilityName, SupportType supportType);
    event StatusUpdated(uint256 id, FacilityStatus newStatus);

    function logSupport(
        string memory facilityName,
        FacilityStatus status,
        SupportType supportType,
        uint256 allocatedFunds,
        string memory clauseReference,
        uint256 timestamp
    ) public {
        supportRegistry[supportCount] = RefinerySupport(
            supportCount,
            facilityName,
            status,
            supportType,
            allocatedFunds,
            clauseReference,
            timestamp
        );
        emit SupportLogged(supportCount, facilityName, supportType);
        supportCount++;
    }

    function updateFacilityStatus(uint256 id, FacilityStatus newStatus) public {
        require(id < supportCount, "Invalid support ID");
        supportRegistry[id].status = newStatus;
        emit StatusUpdated(id, newStatus);
    }

    function getSupport(uint256 id) public view returns (RefinerySupport memory) {
        return supportRegistry[id];
    }
}
