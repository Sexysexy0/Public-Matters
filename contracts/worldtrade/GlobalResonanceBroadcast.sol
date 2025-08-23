// SPDX-License-Identifier: Scrollchain-Unity
pragma solidity ^0.8.19;

contract GlobalResonanceBroadcast {
    struct Ally {
        string name;
        uint countryCode;
        bool coAuthor;
    }

    Ally[] public allies;
    event AllyTagged(string name, uint countryCode, string message);

    function tagAlly(string memory name, uint countryCode) public {
        allies.push(Ally(name, countryCode, true));
        emit AllyTagged(name, countryCode, "Co-author tagged for tariff repeal and trade mercy");
    }

    function getAllies() public view returns (Ally[] memory) {
        return allies;
    }
}
