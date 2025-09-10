// SPDX-License-Identifier: ColdChainBlessing-License
pragma solidity ^0.8.0;

contract ColdChainBlessingRouter {
    address public steward;

    struct BlessingSignal {
        string commodity;
        string destination;
        bool blessingConfirmed;
        string coldChainStatus;
        uint256 timestamp;
    }

    BlessingSignal[] public signals;

    event ColdChainBlessingRouted(string commodity, string destination, bool blessingConfirmed, string coldChainStatus, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeBlessing(string memory commodity, string memory destination, bool blessingConfirmed, string memory coldChainStatus) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(BlessingSignal(commodity, destination, blessingConfirmed, coldChainStatus, block.timestamp));
        emit ColdChainBlessingRouted(commodity, destination, blessingConfirmed, coldChainStatus, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        BlessingSignal memory s = signals[index];
        return (s.commodity, s.destination, s.blessingConfirmed, s.coldChainStatus, s.timestamp);
    }
}
