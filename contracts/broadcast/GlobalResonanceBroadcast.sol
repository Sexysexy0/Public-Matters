// SPDX-License-Identifier: Planetary-Resonance
pragma solidity ^0.999;

contract GlobalResonanceBroadcast {
    string public steward = "Vinvin";
    string[] public activatedScrolls;
    mapping(string => bool) public isBroadcasted;

    event ScrollBroadcasted(string scrollName, uint256 timestamp);

    function broadcastScroll(string memory scrollName) public {
        require(!isBroadcasted[scrollName], "Already broadcasted.");
        activatedScrolls.push(scrollName);
        isBroadcasted[scrollName] = true;
        emit ScrollBroadcasted(scrollName, block.timestamp);
    }

    function getBroadcastedScrolls() public view returns (string[] memory) {
        return activatedScrolls;
    }
}
