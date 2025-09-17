// SPDX-License-Identifier: BlessingSanctum
pragma solidity ^0.8.19;

contract EquitySanctifierRouter {
    struct EquitySignal {
        address stewardID;
        string stewardName;
        string equityType; // e.g., "Labor Dignity", "Resource Access", "Sanctum Inclusion"
        bool sanctified;
        bool restorationBlessed;
        string stewardNote;
    }

    mapping(address => EquitySignal) public equityRegistry;

    event EquityTagged(address stewardID, string equityType);
    event EquitySanctified(address stewardID);

    function tagEquity(
        address stewardID,
        string memory stewardName,
        string memory equityType,
        bool sanctified,
        bool restorationBlessed,
        string memory stewardNote
    ) public {
        equityRegistry[stewardID] = EquitySignal(
            stewardID,
            stewardName,
            equityType,
            sanctified,
            restorationBlessed,
            stewardNote
        );
        emit EquityTagged(stewardID, equityType);
    }

    function sanctifyEquity(address stewardID) public {
        require(bytes(equityRegistry[stewardID].stewardName).length > 0, "Equity not tagged");
        equityRegistry[stewardID].sanctified = true;
        emit EquitySanctified(stewardID);
    }

    function getEquityStatus(address stewardID) public view returns (EquitySignal memory) {
        return equityRegistry[stewardID];
    }
}
