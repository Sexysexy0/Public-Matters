// SPDX-License-Identifier: Blessing-Deck
pragma solidity ^0.8.20;

/// @title BigTechBlessingDeck.sol
/// @dev Tags HQs with civic resonance, Kinder override, and planetary clarity

contract BigTechBlessingDeck {
    address public steward;
    struct HQBlessing {
        string company;
        string location;
        string civicTag;
        bool kinderOverride;
        string planetaryClarityNote;
    }

    HQBlessing[] public blessings;

    event BlessingTagged(string company, string civicTag, bool kinderOverride);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor(address _steward) {
        steward = _steward;
    }

    function tagBlessing(string memory company, string memory location, string memory civicTag, bool kinderOverride, string memory clarityNote) public onlySteward {
        blessings.push(HQBlessing(company, location, civicTag, kinderOverride, clarityNote));
        emit BlessingTagged(company, civicTag, kinderOverride);
    }

    function getBlessings() public view returns (HQBlessing[] memory) {
        return blessings;
    }
}
