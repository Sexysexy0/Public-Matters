// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MaterialRecoveryOracle {
    struct Extraction {
        address player;
        string item;
        uint256 timestamp;
        uint8 refundRate; // percentage refund (70 for common, 100 for rare)
        bool processed;
    }

    Extraction[] public extractions;

    event ExtractionLogged(address indexed player, string item, uint8 refundRate);
    event ExtractionProcessed(uint256 indexed id, address verifier);

    function logExtraction(string memory _item, uint8 _refundRate) public {
        require(_refundRate == 70 || _refundRate == 100, "Invalid refund rate");
        extractions.push(Extraction(msg.sender, _item, block.timestamp, _refundRate, false));
        emit ExtractionLogged(msg.sender, _item, _refundRate);
    }

    function processExtraction(uint256 _id) public {
        require(_id < extractions.length, "Invalid ID");
        extractions[_id].processed = true;
        emit ExtractionProcessed(_id, msg.sender);
    }

    function getExtraction(uint256 _id) public view returns (Extraction memory) {
        require(_id < extractions.length, "Invalid ID");
        return extractions[_id];
    }

    function totalExtractions() public view returns (uint256) {
        return extractions.length;
    }
}
