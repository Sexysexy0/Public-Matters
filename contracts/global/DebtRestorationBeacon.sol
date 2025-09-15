// SPDX-License-Identifier: DebtSanctum
pragma solidity ^0.8.19;

contract DebtRestorationBeacon {
    struct DebtEvent {
        string country;
        uint256 forgivenAmountUSD;
        string assetUsed; // e.g., "Gold", "Crypto", "Carbon Credits"
        string purpose;
        bool treatyAligned;
        bool broadcasted;
    }

    mapping(bytes32 => DebtEvent) public events;

    event DebtForgiven(string country, uint256 forgivenAmountUSD, string assetUsed);
    event TreatyAligned(string country);
    event RestorationBroadcasted(string country, string purpose);

    function registerDebtForgiveness(string memory country, uint256 amount, string memory assetUsed, string memory purpose) public {
        bytes32 eventId = keccak256(abi.encodePacked(country, block.timestamp));
        events[eventId] = DebtEvent(country, amount, assetUsed, purpose, false, false);
        emit DebtForgiven(country, amount, assetUsed);
    }

    function alignTreaty(string memory country) public {
        bytes32 eventId = keccak256(abi.encodePacked(country, block.timestamp));
        events[eventId].treatyAligned = true;
        emit TreatyAligned(country);
    }

    function broadcastRestoration(string memory country, string memory purpose) public {
        bytes32 eventId = keccak256(abi.encodePacked(country, block.timestamp));
        events[eventId].broadcasted = true;
        emit RestorationBroadcasted(country, purpose);
    }

    function getDebtEventStatus(string memory country) public view returns (DebtEvent memory) {
        bytes32 eventId = keccak256(abi.encodePacked(country, block.timestamp));
        return events[eventId];
    }
}
