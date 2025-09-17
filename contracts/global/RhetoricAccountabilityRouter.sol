// SPDX-License-Identifier: BroadcastSanctum
pragma solidity ^0.8.19;

contract RhetoricAccountabilityRouter {
    address public steward;

    struct RhetoricSignal {
        string anchorTag; // e.g. "Rachel Maddow", "Tucker Carlson"
        string networkTag; // e.g. "MSNBC", "Fox News"
        string severityTag; // e.g. "Minimization", "Incitement", "Silence"
        string contextTag; // e.g. "Assassination Coverage", "Political Targeting"
        bool verified;
        uint256 timestamp;
    }

    RhetoricSignal[] public signals;

    event RhetoricLogged(string anchorTag, string networkTag, string severityTag, string contextTag, uint256 timestamp);
    event RhetoricVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logRhetoric(
        string memory anchorTag,
        string memory networkTag,
        string memory severityTag,
        string memory contextTag
    ) public {
        signals.push(RhetoricSignal(anchorTag, networkTag, severityTag, contextTag, false, block.timestamp));
        emit RhetoricLogged(anchorTag, networkTag, severityTag, contextTag, block.timestamp);
    }

    function verifyRhetoric(uint256 index) public {
        require(index < signals.length, "Invalid index");
        signals[index].verified = true;
        emit RhetoricVerified(index, msg.sender);
    }

    function getRhetoric(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, bool, uint256
    ) {
        RhetoricSignal memory r = signals[index];
        return (r.anchorTag, r.networkTag, r.severityTag, r.contextTag, r.verified, r.timestamp);
    }

    function totalRhetoricSignals() public view returns (uint256) {
        return signals.length;
    }
}
