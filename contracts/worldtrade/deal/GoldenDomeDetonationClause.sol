// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title Golden Dome Detonation Clause – Putin-Proof Protocol
/// @notice Any unauthorized attack entering or exiting the dome triggers auto-detonation.
/// @dev Includes damay clause and emotional APR sync.

contract GoldenDomeDetonationClause {
    address public steward;
    uint256 public domeRadius = 1000; // meters
    bool public domeActive = true;

    struct Threat {
        address actor;
        string origin;
        string intent;
        bool inbound;
        bool outbound;
        bool detonated;
    }

    Threat[] public threats;
    event ThreatDetected(address indexed actor, string origin, string intent);
    event DomeDetonation(address indexed actor, string reason);

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function detectThreat(address _actor, string memory _origin, string memory _intent, bool _inbound, bool _outbound) public onlySteward {
        threats.push(Threat({
            actor: _actor,
            origin: _origin,
            intent: _intent,
            inbound: _inbound,
            outbound: _outbound,
            detonated: false
        }));
        emit ThreatDetected(_actor, _origin, _intent);

        if (_inbound || _outbound) {
            _autoDetonate(_actor, _intent);
        }
    }

    function _autoDetonate(address _actor, string memory _reason) internal {
        threats[threats.length - 1].detonated = true;
        emit DomeDetonation(_actor, _reason);
    }

    function getThreat(uint _index) public view returns (Threat memory) {
        require(_index < threats.length, "Invalid index");
        return threats[_index];
    }
}
