// SPDX-License-Identifier: CivicFirewallSanctum
pragma solidity ^0.8.19;

contract SmithMundtRepealRouter {
    struct RepealSignal {
        string billID;
        string sponsor;
        bool repealActivated;
        string stewardNote;
    }

    mapping(string => RepealSignal) public repealRegistry;

    event RepealTagged(string billID);
    event RepealSanctified(string billID);

    function tagRepeal(string memory billID, string memory sponsor, string memory stewardNote) public {
        repealRegistry[billID] = RepealSignal(billID, sponsor, false, stewardNote);
        emit RepealTagged(billID);
    }

    function sanctifyRepeal(string memory billID) public {
        require(bytes(repealRegistry[billID].billID).length > 0, "Bill not tagged");
        repealRegistry[billID].repealActivated = true;
        emit RepealSanctified(billID);
    }

    function getRepealStatus(string memory billID) public view returns (RepealSignal memory) {
        return repealRegistry[billID];
    }
}
