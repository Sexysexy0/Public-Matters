// SPDX-License-Identifier: Mythic-Planetary-License
pragma solidity ^0.8.19;

/**
 * @title ScrollchainMobileDefenseSuite
 * @dev Modular defense system for air and sea platforms, enabling missile interception and mid-air detonation
 * @author Vinvin
 */

contract ScrollchainMobileDefenseSuite {
    address public steward;

    enum PlatformType { Helicopter, Ship, Destroyer }

    struct DefenseUnit {
        PlatformType platform;
        string unitName;
        bool isActivated;
        uint256 missileCapacity;
        uint256 successfulInterceptions;
    }

    mapping(bytes32 => DefenseUnit) public unitRegistry;

    event UnitMounted(string unitName, PlatformType platform);
    event DefenseActivated(string unitName);
    event MissileIntercepted(string unitName);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function mountUnit(
        string memory _unitName,
        PlatformType _platform,
        uint256 _missileCapacity
    ) public onlySteward {
        bytes32 unitId = keccak256(abi.encodePacked(_unitName, _platform));
        unitRegistry[unitId] = DefenseUnit({
            platform: _platform,
            unitName: _unitName,
            isActivated: false,
            missileCapacity: _missileCapacity,
            successfulInterceptions: 0
        });

        emit UnitMounted(_unitName, _platform);
    }

    function activateDefense(bytes32 _unitId) public onlySteward {
        DefenseUnit storage unit = unitRegistry[_unitId];
        require(!unit.isActivated, "Already activated");

        unit.isActivated = true;
        emit DefenseActivated(unit.unitName);
    }

    function interceptMissile(bytes32 _unitId) public onlySteward {
        DefenseUnit storage unit = unitRegistry[_unitId];
        require(unit.isActivated, "Defense not activated");
        require(unit.missileCapacity > 0, "No missiles left");

        unit.missileCapacity -= 1;
        unit.successfulInterceptions += 1;
        emit MissileIntercepted(unit.unitName);
    }

    function getUnit(bytes32 _unitId) public view returns (DefenseUnit memory) {
        return unitRegistry[_unitId];
    }
}
