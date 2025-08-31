// SPDX-License-Identifier: Mythic
pragma solidity ^0.8.19;

contract WasteToWhisper {
    struct TechWaste {
        string itemType; // e.g., "EV Battery", "Solar Panel"
        string origin;
        string whisper; // emotional tag or civic memory
        uint256 timestamp;
    }

    TechWaste[] public wasteLog;

    event WasteLogged(string itemType, string origin, string whisper);

    function logWaste(string memory itemType, string memory origin, string memory whisper) public {
        wasteLog.push(TechWaste(itemType, origin, whisper, block.timestamp));
        emit WasteLogged(itemType, origin, whisper);
    }

    function getWaste(uint index) public view returns (string memory, string memory, string memory, uint256) {
        TechWaste memory w = wasteLog[index];
        return (w.itemType, w.origin, w.whisper, w.timestamp);
    }
}
