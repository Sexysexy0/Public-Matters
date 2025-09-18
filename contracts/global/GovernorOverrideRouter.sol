// SPDX-License-Identifier: OverrideSanctum
pragma solidity ^0.8.19;

contract GovernorOverrideRouter {
    address public steward;

    struct OverrideSignal {
        string region; // e.g. "California"
        string breachType; // e.g. "Mass Release", "Ideological Capture"
        string overrideAction; // e.g. "Executive Nullification", "Military Deployment", "Sanctum Reboot"
        bool verified;
        uint256 timestamp;
    }

    OverrideSignal[] public signals;

    event OverrideLogged(string region, string breachType, string overrideAction, uint256 timestamp);
    event OverrideVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logOverride(
        string memory region,
        string memory breachType,
        string memory overrideAction
    ) public {
        signals.push(OverrideSignal(region, breachType, overrideAction, false, block.timestamp));
        emit OverrideLogged(region, breachType, overrideAction, block.timestamp);
    }

    function verifyOverride(uint256 index) public {
        require(index < signals.length, "Invalid index");
        signals[index].verified = true;
        emit OverrideVerified(index, msg.sender);
    }

    function getOverride(uint256 index) public view returns (
        string memory, string memory, string memory, bool, uint256
    ) {
        OverrideSignal memory o = signals[index];
        return (o.region, o.breachType, o.overrideAction, o.verified, o.timestamp);
    }

    function totalOverrideSignals() public view returns (uint256) {
        return signals.length;
    }
}
