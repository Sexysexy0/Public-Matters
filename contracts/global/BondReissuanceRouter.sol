// SPDX-License-Identifier: TreasurySanctum
pragma solidity ^0.8.19;

contract BondReissuanceRouter {
    address public steward;

    struct ReissuanceEvent {
        string jurisdiction;
        string bondType;
        uint256 maturedVolumeUSD;
        uint256 reissuedVolumeUSD;
        string reinvestmentChannel;
        uint256 timestamp;
        bool verified;
    }

    ReissuanceEvent[] public events;

    event ReissuanceLogged(string jurisdiction, string bondType, uint256 maturedVolumeUSD, uint256 reissuedVolumeUSD, string reinvestmentChannel, uint256 timestamp);
    event ReissuanceVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logReissuanceEvent(
        string memory jurisdiction,
        string memory bondType,
        uint256 maturedVolumeUSD,
        uint256 reissuedVolumeUSD,
        string memory reinvestmentChannel
    ) public {
        events.push(ReissuanceEvent(jurisdiction, bondType, maturedVolumeUSD, reissuedVolumeUSD, reinvestmentChannel, block.timestamp, false));
        emit ReissuanceLogged(jurisdiction, bondType, maturedVolumeUSD, reissuedVolumeUSD, reinvestmentChannel, block.timestamp);
    }

    function verifyReissuance(uint256 index) public {
        require(index < events.length, "Invalid index");
        events[index].verified = true;
        emit ReissuanceVerified(index, msg.sender);
    }

    function getReissuanceEvent(uint256 index) public view returns (
        string memory, string memory, uint256, uint256, string memory, uint256, bool
    ) {
        ReissuanceEvent memory e = events[index];
        return (e.jurisdiction, e.bondType, e.maturedVolumeUSD, e.reissuedVolumeUSD, e.reinvestmentChannel, e.timestamp, e.verified);
    }

    function totalEvents() public view returns (uint256) {
        return events.length;
    }
}
