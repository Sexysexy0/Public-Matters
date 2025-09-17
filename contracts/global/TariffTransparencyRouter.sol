// SPDX-License-Identifier: TradeClaritySanctum
pragma solidity ^0.8.19;

contract TariffTransparencyRouter {
    address public steward;

    struct TariffRecord {
        string product;
        string origin;
        string destination;
        uint256 tariffRate;
        string exemptionTag; // e.g. "Humanitarian", "Treaty-Based", "Diaspora Corridor"
        bool verified;
        uint256 timestamp;
    }

    TariffRecord[] public records;

    event TariffLogged(string product, string origin, string destination, uint256 tariffRate, string exemptionTag, uint256 timestamp);
    event TariffVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logTariff(
        string memory product,
        string memory origin,
        string memory destination,
        uint256 tariffRate,
        string memory exemptionTag
    ) public {
        records.push(TariffRecord(product, origin, destination, tariffRate, exemptionTag, false, block.timestamp));
        emit TariffLogged(product, origin, destination, tariffRate, exemptionTag, block.timestamp);
    }

    function verifyTariff(uint256 index) public {
        require(index < records.length, "Invalid index");
        records[index].verified = true;
        emit TariffVerified(index, msg.sender);
    }

    function getTariff(uint256 index) public view returns (
        string memory, string memory, string memory, uint256, string memory, bool, uint256
    ) {
        TariffRecord memory t = records[index];
        return (t.product, t.origin, t.destination, t.tariffRate, t.exemptionTag, t.verified, t.timestamp);
    }

    function totalTariffs() public view returns (uint256) {
        return records.length;
    }
}
