// SPDX-License-Identifier: DignitySanctum
pragma solidity ^0.8.19;

contract SavingsDignityRouter {
    struct DignitySignal {
        string jurisdiction;
        uint256 capAmount;
        bool repealed;
        string stewardNote;
    }

    mapping(string => DignitySignal) public dignityRegistry;

    event CapTagged(string jurisdiction, uint256 capAmount);
    event DignityRestored(string jurisdiction);

    function tagCap(string memory jurisdiction, uint256 capAmount, string memory stewardNote) public {
        dignityRegistry[jurisdiction] = DignitySignal(jurisdiction, capAmount, false, stewardNote);
        emit CapTagged(jurisdiction, capAmount);
    }

    function restoreDignity(string memory jurisdiction) public {
        require(dignityRegistry[jurisdiction].capAmount > 0, "Cap not tagged");
        dignityRegistry[jurisdiction].repealed = true;
        emit DignityRestored(jurisdiction);
    }

    function getDignityStatus(string memory jurisdiction) public view returns (DignitySignal memory) {
        return dignityRegistry[jurisdiction];
    }
}
