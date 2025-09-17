// SPDX-License-Identifier: IndexSanctum
pragma solidity ^0.8.19;

contract IndexImbalanceScanner {
    address public steward;

    struct ImbalanceRecord {
        string indexTag; // e.g. "S&P 500", "QQQ", "MAGX"
        uint256 top7Weight; // percentage of index held by Magnificent Seven
        uint256 restWeight; // percentage held by remaining constituents
        string imbalanceSignal; // e.g. "Overconcentrated", "Volatility Risk", "Earnings Divergence"
        bool verified;
        uint256 timestamp;
    }

    ImbalanceRecord[] public records;

    event ImbalanceLogged(string indexTag, uint256 top7Weight, uint256 restWeight, string imbalanceSignal, uint256 timestamp);
    event ImbalanceVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logImbalance(
        string memory indexTag,
        uint256 top7Weight,
        uint256 restWeight,
        string memory imbalanceSignal
    ) public {
        records.push(ImbalanceRecord(indexTag, top7Weight, restWeight, imbalanceSignal, false, block.timestamp));
        emit ImbalanceLogged(indexTag, top7Weight, restWeight, imbalanceSignal, block.timestamp);
    }

    function verifyImbalance(uint256 index) public {
        require(index < records.length, "Invalid index");
        records[index].verified = true;
        emit ImbalanceVerified(index, msg.sender);
    }

    function getImbalance(uint256 index) public view returns (
        string memory, uint256, uint256, string memory, bool, uint256
    ) {
        ImbalanceRecord memory r = records[index];
        return (r.indexTag, r.top7Weight, r.restWeight, r.imbalanceSignal, r.verified, r.timestamp);
    }

    function totalImbalances() public view returns (uint256) {
        return records.length;
    }
}
