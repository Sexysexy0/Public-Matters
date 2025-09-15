// SPDX-License-Identifier: CanalSanctum
pragma solidity ^0.8.19;

contract CanalDisplacementBlessingRouter {
    struct Zone {
        string name;
        bool taggedForDisplacement;
        uint256 payoutAmount;
        bool councilApproved;
        bool treatyAligned;
    }

    mapping(bytes32 => Zone) public zones;

    event ZoneTagged(string name, uint256 payoutAmount);
    event CouncilApproved(string name);
    event TreatyAligned(string name);

    function tagZone(string memory name, uint256 payoutAmount) public {
        bytes32 zoneId = keccak256(abi.encodePacked(name));
        zones[zoneId] = Zone(name, true, payoutAmount, false, false);
        emit ZoneTagged(name, payoutAmount);
    }

    function approveByCouncil(string memory name) public {
        bytes32 zoneId = keccak256(abi.encodePacked(name));
        zones[zoneId].councilApproved = true;
        emit CouncilApproved(name);
    }

    function alignWithTreaty(string memory name) public {
        bytes32 zoneId = keccak256(abi.encodePacked(name));
        zones[zoneId].treatyAligned = true;
        emit TreatyAligned(name);
    }

    function getZoneStatus(string memory name) public view returns (Zone memory) {
        bytes32 zoneId = keccak256(abi.encodePacked(name));
        return zones[zoneId];
    }
}
