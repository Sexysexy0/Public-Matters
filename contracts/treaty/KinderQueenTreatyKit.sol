// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract KinderQueenTreatyKit {
    struct Treaty {
        string lesson;
        uint256 timestamp;
        uint8 trust;
        uint8 empathy;
        uint8 clarity;
    }

    Treaty[] public scrolls;

    event TreatySigned(string lesson, uint256 timestamp, uint8 trust, uint8 empathy, uint8 clarity);

    function signTreaty(string memory lesson, uint8 trust, uint8 empathy, uint8 clarity) public {
        Treaty memory newTreaty = Treaty(lesson, block.timestamp, trust, empathy, clarity);
        scrolls.push(newTreaty);
        emit TreatySigned(lesson, block.timestamp, trust, empathy, clarity);
    }

    function getTreaty(uint index) public view returns (Treaty memory) {
        require(index < scrolls.length, "Scroll not found");
        return scrolls[index];
    }
}
