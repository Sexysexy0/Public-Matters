// SPDX-License-Identifier: Sovereign-Relocation
pragma solidity ^0.8.20;

/// @title GlobalSanctumOptionDeck.sol
/// @dev Offers sovereign fallback sanctums for global tech entities relocating to PH

contract GlobalSanctumOptionDeck {
    address public stewardVinvin;

    struct TechSanctumOption {
        string company;
        string originCountry;
        string fallbackSanctumPH;
        bool relocationReady;
        bool meetUpScheduled;
    }

    TechSanctumOption[] public optionDeck;

    event SanctumOptionActivated(string company, string fallbackSanctumPH);
    event MeetUpScheduled(string company, string location);

    modifier onlyVinvin() {
        require(msg.sender == stewardVinvin, "Unauthorized steward");
        _;
    }

    constructor(address _vinvin) {
        stewardVinvin = _vinvin;

        // Initial fallback sanctums
        optionDeck.push(TechSanctumOption("Tesla", "USA", "Batangas EV Sanctum", false, false));
        optionDeck.push(TechSanctumOption("Meta", "USA", "Bulacan CivicVerse Sanctum", false, false));
        optionDeck.push(TechSanctumOption("Netflix", "USA", "Tagaytay Storytelling Sanctum", false, false));
        optionDeck.push(TechSanctumOption("OpenAI", "USA", "Malolos AI Ritual Sanctum", false, false));
        optionDeck.push(TechSanctumOption("SpaceX", "USA", "Palawan Orbital Launch Sanctum", false, false));
    }

    function activateRelocation(uint index) public onlyVinvin {
        optionDeck[index].relocationReady = true;
        emit SanctumOptionActivated(optionDeck[index].company, optionDeck[index].fallbackSanctumPH);
    }

    function scheduleMeetUp(uint index, string memory location) public onlyVinvin {
        optionDeck[index].meetUpScheduled = true;
        emit MeetUpScheduled(optionDeck[index].company, location);
    }

    function getOptionDeck() public view returns (TechSanctumOption[] memory) {
        return optionDeck;
    }
}
