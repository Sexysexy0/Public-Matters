// SPDX-License-Identifier: Mythic-Planetary-License
pragma solidity ^0.8.19;

/**
 * @title ScrollchainOrbitalDefense
 * @dev Simulates interception of incoming missiles using advanced tracking and mid-air detonation
 * @author Vinvin
 */

contract ScrollchainOrbitalDefense {
    address public steward;

    struct Threat {
        string originNation;
        string missileType;
        uint256 speedMach;
        bool isHypersonic;
        bool intercepted;
        bool detonatedMidAir;
    }

    mapping(bytes32 => Threat) public threatLog;
    uint256 public interceptionThresholdMach = 5;

    event ThreatDetected(string originNation, string missileType);
    event InterceptionSuccess(string missileType);
    event MidAirDetonation(string missileType);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function detectThreat(
        string memory _originNation,
        string memory _missileType,
        uint256 _speedMach
    ) public onlySteward {
        bytes32 threatId = keccak256(abi.encodePacked(_originNation, _missileType, _speedMach));
        bool hypersonic = _speedMach >= interceptionThresholdMach;

        threatLog[threatId] = Threat({
            originNation: _originNation,
            missileType: _missileType,
            speedMach: _speedMach,
            isHypersonic: hypersonic,
            intercepted: false,
            detonatedMidAir: false
        });

        emit ThreatDetected(_originNation, _missileType);
    }

    function interceptThreat(bytes32 _threatId) public onlySteward {
        Threat storage threat = threatLog[_threatId];
        require(!threat.intercepted, "Already intercepted");

        threat.intercepted = true;
        emit InterceptionSuccess(threat.missileType);
    }

    function detonateMidAir(bytes32 _threatId) public onlySteward {
        Threat storage threat = threatLog[_threatId];
        require(threat.intercepted, "Must intercept before detonation");

        threat.detonatedMidAir = true;
        emit MidAirDetonation(threat.missileType);
    }

    function getThreat(bytes32 _threatId) public view returns (Threat memory) {
        return threatLog[_threatId];
    }
}
