// SPDX-License-Identifier: Blessing-Ledger
pragma solidity ^0.8.25;

/// @title TradeBlessingLedger.sol  
/// @dev Tracks trade blessings granted to small sellers and global exporters

contract TradeBlessingLedger {
    address public steward;

    struct Blessing {
        string region;
        string sellerType;
        uint8 trust;
        uint8 empathy;
        uint8 clarity;
        uint256 timestamp;
    }

    Blessing[] public blessings;

    event TradeBlessingLogged(string region, string sellerType, uint8 trust, uint8 empathy, uint8 clarity, uint256 timestamp);

    constructor() {
        steward = msg.sender;
    }

    function logBlessing(string memory region, string memory sellerType, uint8 trust, uint8 empathy, uint8 clarity) public {
        require(msg.sender == steward, "Unauthorized steward");
        Blessing memory newBlessing = Blessing(region, sellerType, trust, empathy, clarity, block.timestamp);
        blessings.push(newBlessing);
        emit TradeBlessingLogged(region, sellerType, trust, empathy, clarity, block.timestamp);
    }

    function getBlessing(uint index) public view returns (string memory, string memory, uint8, uint8, uint8, uint256) {
        Blessing memory b = blessings[index];
        return (b.region, b.sellerType, b.trust, b.empathy, b.clarity, b.timestamp);
    }

    function totalBlessings() public view returns (uint) {
        return blessings.length;
    }
}
