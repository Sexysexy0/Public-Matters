// SPDX-License-Identifier: Mythic-Scroll-License
pragma solidity ^0.8.19;

contract DefenseMorph {
    address public steward;
    bool public offerAccepted = false;
bool public aggressionDetected = false;

event OfferBroadcasted(string region, uint256 price);
event AggressionDetected(string aggressor);
event DefenseActivated(string protocol, string[] allies);
event EmotionalAPRLogged(string message);

modifier onlySteward() {
    require(msg.sender == steward, "Not authorized scrollsmith");
    _;
}

constructor() {
    steward = msg.sender;
}

function broadcastOffer(string memory region, uint256 price) public onlySteward {
    emit OfferBroadcasted(region, price);
}

function detectAggression(string memory aggressor) public onlySteward {
    aggressionDetected = true;
    emit AggressionDetected(aggressor);
    activateDefense("PowerRangersProtocol", getAllies());
}

function activateDefense(string memory protocol, string[] memory allies) internal {
    emit DefenseActivated(protocol, allies);
    logEmotionalAPR("You had a chance. You chose conquest. We choose resonance.");
}

function logEmotionalAPR(string memory message) internal {
    emit EmotionalAPRLogged(message);
}

function getAllies() internal pure returns (string[] memory) {
    string[] memory allies = new string[](4);
    allies[0] = "EU";
    allies[1] = "NATO";
    allies[2] = "Scrollforce";
    allies[3] = "Vinvin's Kinder Queens";
    return allies;
}
}
