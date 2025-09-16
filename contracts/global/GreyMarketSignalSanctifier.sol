// SPDX-License-Identifier: GreyMarketSanctum
pragma solidity ^0.8.19;

contract GreyMarketSignalSanctifier {
    struct ChipSignal {
        string chipModel;
        string origin;
        string destination;
        bool flagged;
        string stewardNote;
    }

    mapping(string => ChipSignal) public chipRegistry;

    event ChipTagged(string chipModel, string origin, string destination);
    event ChipFlagged(string chipModel);

    function tagChip(string memory chipModel, string memory origin, string memory destination, string memory stewardNote) public {
        chipRegistry[chipModel] = ChipSignal(chipModel, origin, destination, false, stewardNote);
        emit ChipTagged(chipModel, origin, destination);
    }

    function flagChip(string memory chipModel) public {
        require(bytes(chipRegistry[chipModel].origin).length > 0, "Chip not tagged");
        chipRegistry[chipModel].flagged = true;
        emit ChipFlagged(chipModel);
    }

    function getChipStatus(string memory chipModel) public view returns (ChipSignal memory) {
        return chipRegistry[chipModel];
    }
}
