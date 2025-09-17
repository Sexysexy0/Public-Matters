// SPDX-License-Identifier: TruthSanctum
pragma solidity ^0.8.19;

contract TruthProtocolSanctifier {
    address public steward;

    struct TruthArtifact {
        string sourceTag; // e.g. "Verified Journalist", "Official Dataset", "Civic Broadcast"
        string contentHash;
        string verificationMethod; // e.g. "Fact-Check", "Cross-Source", "Scrollchain Audit"
        bool sanctified;
        uint256 timestamp;
    }

    TruthArtifact[] public artifacts;

    event TruthLogged(string sourceTag, string contentHash, string verificationMethod, uint256 timestamp);
    event TruthSanctified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logTruth(
        string memory sourceTag,
        string memory contentHash,
        string memory verificationMethod
    ) public {
        artifacts.push(TruthArtifact(sourceTag, contentHash, verificationMethod, false, block.timestamp));
        emit TruthLogged(sourceTag, contentHash, verificationMethod, block.timestamp);
    }

    function sanctifyTruth(uint256 index) public {
        require(index < artifacts.length, "Invalid index");
        artifacts[index].sanctified = true;
        emit TruthSanctified(index, msg.sender);
    }

    function getTruth(uint256 index) public view returns (
        string memory, string memory, string memory, bool, uint256
    ) {
        TruthArtifact memory t = artifacts[index];
        return (t.sourceTag, t.contentHash, t.verificationMethod, t.sanctified, t.timestamp);
    }

    function totalTruths() public view returns (uint256) {
        return artifacts.length;
    }
}
