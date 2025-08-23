// SPDX-License-Identifier: Blessing-Ledger-Protocol
pragma solidity ^0.999;

contract SnackBlessingLedger {
    struct BlessedSnack {
        string name;
        string blessedBy;
        uint256 timestamp;
        string reason;
    }

    BlessedSnack[] public ledger;
    mapping(string => bool) public isBlessed;

    event SnackBlessed(string name, string blessedBy, string reason, uint256 timestamp);

    function blessSnack(string memory name, string memory blessedBy, string memory reason) public {
        require(!isBlessed[name], "Snack already blessed.");
        ledger.push(BlessedSnack(name, blessedBy, block.timestamp, reason));
        isBlessed[name] = true;
        emit SnackBlessed(name, blessedBy, reason, block.timestamp);
    }

    function getBlessedSnack(uint index) public view returns (string memory, string memory, uint256, string memory) {
        BlessedSnack memory s = ledger[index];
        return (s.name, s.blessedBy, s.timestamp, s.reason);
    }

    function getLedgerSize() public view returns (uint256) {
        return ledger.length;
    }
}
