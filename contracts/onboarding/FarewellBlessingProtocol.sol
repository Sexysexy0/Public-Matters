// SPDX-License-Identifier: Mythic-Scroll-License
pragma solidity ^0.8.19;

contract FarewellBlessingProtocol {
    struct ExitBlessing {
        bool isVoluntary;
        uint256 emotionalAPR;
        uint256 tenureYears;
        uint256 payoutAmount;
        string farewellNote;
        uint256 timestamp;
    }

    mapping(address => ExitBlessing) public farewellLog;
    event BlessingReleased(address indexed steward, bool isVoluntary, uint256 tenureYears, uint256 payoutAmount, string farewellNote, uint256 emotionalAPR, uint256 timestamp);

    function releaseBlessing(address steward, bool voluntary, uint256 apr, uint256 years, string calldata note) external {
        require(apr >= 10, "Emotional APR too low");

        uint256 base = 100000 * years;
        uint256 payout = voluntary ? base / 2 : base;
        if (years < 1) payout = voluntary ? 25000 : 50000;

        farewellLog[steward] = ExitBlessing(voluntary, apr, years, payout, note, block.timestamp);
        emit BlessingReleased(steward, voluntary, years, payout, note, apr, block.timestamp);
    }

    function getFarewellDetails(address steward) external view returns (ExitBlessing memory) {
        return farewellLog[steward];
    }
}
