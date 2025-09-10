// SPDX-License-Identifier: PetrodollarBlessing-License
pragma solidity ^0.8.0;

contract PetrodollarBlessingRouter {
    address public steward;

    struct BlessingSignal {
        string originPair;
        string reroutedPair;
        bool blessingConfirmed;
        string blessingType;
        uint256 timestamp;
    }

    BlessingSignal[] public signals;

    event BlessingRouted(string originPair, string reroutedPair, bool blessingConfirmed, string blessingType, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeBlessing(string memory originPair, string memory reroutedPair, bool blessingConfirmed, string memory blessingType) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(BlessingSignal(originPair, reroutedPair, blessingConfirmed, blessingType, block.timestamp));
        emit BlessingRouted(originPair, reroutedPair, blessingConfirmed, blessingType, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        BlessingSignal memory s = signals[index];
        return (s.originPair, s.reroutedPair, s.blessingConfirmed, s.blessingType, s.timestamp);
    }
}
