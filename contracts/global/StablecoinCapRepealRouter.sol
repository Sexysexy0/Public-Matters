// SPDX-License-Identifier: SovereignSavingsSanctum
pragma solidity ^0.8.19;

contract StablecoinCapRepealRouter {
    struct CapSignal {
        string jurisdiction;
        uint256 individualCap;
        uint256 businessCap;
        bool repealed;
        string stewardNote;
    }

    mapping(string => CapSignal) public capRegistry;

    event CapTagged(string jurisdiction, uint256 individualCap, uint256 businessCap);
    event CapRepealed(string jurisdiction);

    function tagCap(string memory jurisdiction, uint256 individualCap, uint256 businessCap, string memory stewardNote) public {
        capRegistry[jurisdiction] = CapSignal(jurisdiction, individualCap, businessCap, false, stewardNote);
        emit CapTagged(jurisdiction, individualCap, businessCap);
    }

    function repealCap(string memory jurisdiction) public {
        require(capRegistry[jurisdiction].individualCap > 0, "Cap not tagged");
        capRegistry[jurisdiction].repealed = true;
        emit CapRepealed(jurisdiction);
    }

    function getCapStatus(string memory jurisdiction) public view returns (CapSignal memory) {
        return capRegistry[jurisdiction];
    }
}
