// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract EvidenceRegistry {
    string[] private evidences;

    function registerEvidence(string memory doc) public {
        evidences.push(doc);
    }

    function getEvidence(uint256 index) public view returns (string memory) {
        require(index < evidences.length, "Invalid index");
        return evidences[index];
    }

    function totalEvidences() public view returns (uint256) {
        return evidences.length;
    }
}
