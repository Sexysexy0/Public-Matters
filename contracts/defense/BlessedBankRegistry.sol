// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BlessedBankRegistry {
    address public steward;

    struct BlessedBank {
        address bank;
        string institutionName;
        string originTag;
        string blessingNote;
        uint256 timestamp;
    }

    BlessedBank[] public registry;

    event BankBlessed(address indexed bank, string institutionName, string originTag, string blessingNote, uint256 timestamp);

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function blessBank(address bank, string memory institutionName, string memory originTag, string memory blessingNote) public onlySteward {
        registry.push(BlessedBank(bank, institutionName, originTag, blessingNote, block.timestamp));
        emit BankBlessed(bank, institutionName, originTag, blessingNote, block.timestamp);
    }

    function getBlessedBanks() public view returns (BlessedBank[] memory) {
        return registry;
    }
}
