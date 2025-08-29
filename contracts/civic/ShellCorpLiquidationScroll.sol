// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract ShellCorpLiquidationScroll {
    address public steward;

    struct ShellCorp {
        string corpName;
        string owner;
        uint256 assetValue;
        bool liquidated;
        string redirectedSector;
        uint256 timestamp;
    }

    ShellCorp[] public corps;

    event CorpLiquidated(string corpName, string owner, uint256 assetValue);

    constructor() {
        steward = msg.sender;
    }

    function liquidateCorp(
        string memory corpName,
        string memory owner,
        uint256 assetValue,
        string memory redirectedSector
    ) public {
        corps.push(ShellCorp(corpName, owner, assetValue, true, redirectedSector, block.timestamp));
        emit CorpLiquidated(corpName, owner, assetValue);
    }

    function getCorp(uint256 index) public view returns (ShellCorp memory) {
        return corps[index];
    }

    function totalCorps() public view returns (uint256) {
        return corps.length;
    }
}
