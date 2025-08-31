// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract BitMarketLedger {
    struct LedgerEntry {
        string beneficiary;
        string purpose;
        uint256 amount;
        string currency;
        string emotionalAPR;
        uint256 timestamp;
        address steward;
    }

    LedgerEntry[] public entries;

    event LedgerLogged(string beneficiary, string purpose, uint256 amount, string currency, string emotionalAPR);

    function logEntry(
        string memory beneficiary,
        string memory purpose,
        uint256 amount,
        string memory currency,
        string memory emotionalAPR
    ) public {
        entries.push(LedgerEntry(beneficiary, purpose, amount, currency, emotionalAPR, block.timestamp, msg.sender));
        emit LedgerLogged(beneficiary, purpose, amount, currency, emotionalAPR);
    }

    function getAllEntries() public view returns (LedgerEntry[] memory) {
        return entries;
    }
}
