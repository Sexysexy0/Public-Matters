// SPDX-License-Identifier: TariffBlessing-License
pragma solidity ^0.8.0;

contract TreatyTariffBlessingKit {
    address public steward;

    struct TariffBlessing {
        string country;
        uint256 tariffRate;
        string blessingClause;
        bool verified;
        uint256 timestamp;
    }

    TariffBlessing[] public blessings;

    event TariffBlessingIssued(string country, uint256 rate, string clause, bool verified, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function issueBlessing(string memory country, uint256 tariffRate, string memory blessingClause, bool verified) public {
        require(msg.sender == steward, "Only steward can issue");
        blessings.push(TariffBlessing(country, tariffRate, blessingClause, verified, block.timestamp));
        emit TariffBlessingIssued(country, tariffRate, blessingClause, verified, block.timestamp);
    }

    function getBlessing(uint index) public view returns (string memory, uint256, string memory, bool, uint256) {
        TariffBlessing memory b = blessings[index];
        return (b.country, b.tariffRate, b.blessingClause, b.verified, b.timestamp);
    }
}
