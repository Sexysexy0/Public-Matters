// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract KinderSanctumFund {
    address public steward;

    struct FundEntry {
        string source;
        uint256 amount;
        string emotionalTag;
        string purpose;
        uint256 timestamp;
    }

    FundEntry[] public entries;

    event FundRedirected(string source, uint256 amount, string purpose);

    constructor() {
        steward = msg.sender;
    }

    function redirectFund(
        string memory source,
        uint256 amount,
        string memory emotionalTag,
        string memory purpose
    ) public {
        entries.push(FundEntry(source, amount, emotionalTag, purpose, block.timestamp));
        emit FundRedirected(source, amount, purpose);
    }

    function getFundEntry(uint256 index) public view returns (FundEntry memory) {
        return entries[index];
    }

    function totalEntries() public view returns (uint256) {
        return entries.length;
    }
}
