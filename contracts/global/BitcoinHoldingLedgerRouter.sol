// SPDX-License-Identifier: TreasurySanctum
pragma solidity ^0.8.19;

contract BitcoinHoldingLedgerRouter {
    address public steward;

    struct BTCReserve {
        string institution;
        uint256 btcAmount;
        string yieldStrategy; // e.g. "Staking", "Lending", "ETF", "StablecoinYield"
        string jurisdiction;
        bool treasuryTagged;
        uint256 timestamp;
    }

    BTCReserve[] public reserves;

    event ReserveLogged(string institution, uint256 btcAmount, string yieldStrategy, string jurisdiction, bool treasuryTagged, uint256 timestamp);
    event TreasuryTagged(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logBTCReserve(
        string memory institution,
        uint256 btcAmount,
        string memory yieldStrategy,
        string memory jurisdiction,
        bool treasuryTagged
    ) public {
        reserves.push(BTCReserve(institution, btcAmount, yieldStrategy, jurisdiction, treasuryTagged, block.timestamp));
        emit ReserveLogged(institution, btcAmount, yieldStrategy, jurisdiction, treasuryTagged, block.timestamp);
    }

    function tagAsTreasuryGrade(uint256 index) public {
        require(index < reserves.length, "Invalid index");
        reserves[index].treasuryTagged = true;
        emit TreasuryTagged(index, msg.sender);
    }

    function getBTCReserve(uint256 index) public view returns (
        string memory, uint256, string memory, string memory, bool, uint256
    ) {
        BTCReserve memory r = reserves[index];
        return (r.institution, r.btcAmount, r.yieldStrategy, r.jurisdiction, r.treasuryTagged, r.timestamp);
    }

    function totalReserves() public view returns (uint256) {
        return reserves.length;
    }
}
