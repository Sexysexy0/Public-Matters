// SPDX-License-Identifier: ImportSanctum
pragma solidity ^0.8.19;

contract ImportTableReconstructionRouter {
    struct ImportSignal {
        string binaryHash;
        string suspectedPacker;
        string oepAddress;
        uint256 entropyScore;
        bool reconstructionTriggered;
        string stewardNote;
    }

    mapping(string => ImportSignal) public signals;

    event ImportTagged(string binaryHash, string suspectedPacker);
    event ReconstructionActivated(string binaryHash);

    function tagImport(string memory binaryHash, string memory suspectedPacker, string memory oepAddress, uint256 entropyScore, string memory stewardNote) public {
        signals[binaryHash] = ImportSignal(binaryHash, suspectedPacker, oepAddress, entropyScore, false, stewardNote);
        emit ImportTagged(binaryHash, suspectedPacker);
    }

    function activateReconstruction(string memory binaryHash) public {
        require(signals[binaryHash].entropyScore >= 7, "Entropy not high enough to trigger reconstruction");
        signals[binaryHash].reconstructionTriggered = true;
        emit ReconstructionActivated(binaryHash);
    }

    function getImportStatus(string memory binaryHash) public view returns (ImportSignal memory) {
        return signals[binaryHash];
    }
}
