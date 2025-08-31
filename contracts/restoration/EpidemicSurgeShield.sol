// SPDX-License-Identifier: Mythic-7
pragma solidity ^0.8.19;

/// @title EpidemicSurgeShield.sol
/// @notice Activates overflow protocols and reroutes patients during outbreaks
contract EpidemicSurgeShield {
    address public steward;

    struct Patient {
        address wallet;
        string condition;
        bool rerouted;
        string safeZone;
        uint256 timestamp;
    }

    Patient[] public rerouteLog;

    event PatientRerouted(address indexed wallet, string condition, string safeZone);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function reroutePatient(address wallet, string memory condition, string memory safeZone) public onlySteward {
        rerouteLog.push(Patient(wallet, condition, true, safeZone, block.timestamp));
        emit PatientRerouted(wallet, condition, safeZone);
    }

    function getReroute(uint256 index) public view returns (Patient memory) {
        require(index < rerouteLog.length, "Scroll not found");
        return rerouteLog[index];
    }

    function totalReroutes() public view returns (uint256) {
        return rerouteLog.length;
    }
}
