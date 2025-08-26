// SPDX-License-Identifier: Mythic-Planetary-License
pragma solidity ^0.8.19;

/**
 * @title TradeBlessingDeck
 * @dev Tags nations with exports, imports, and emotional APR for dignified trade
 */

contract TradeBlessingDeck {
    struct TradeProfile {
        string nation;
        string[] exports;
        string[] imports;
        uint256 emotionalAPR;
        bool approved;
    }

    mapping(string => TradeProfile) public blessings;

    function blessNation(
        string memory _nation,
        string[] memory _exports,
        string[] memory _imports,
        uint256 _apr
    ) public {
        require(_apr >= 800, "APR too low for blessing");

        blessings[_nation] = TradeProfile({
            nation: _nation,
            exports: _exports,
            imports: _imports,
            emotionalAPR: _apr,
            approved: true
        });
    }

    function getBlessing(string memory _nation) public view returns (TradeProfile memory) {
        return blessings[_nation];
    }
}
