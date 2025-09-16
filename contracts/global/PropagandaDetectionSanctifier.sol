// SPDX-License-Identifier: PropagandaSanctum
pragma solidity ^0.8.19;

contract PropagandaDetectionSanctifier {
    struct PropagandaSignal {
        string contentHash;
        string narrativeType;
        string detectionMethod;
        bool flagged;
        string stewardNote;
    }

    mapping(string => PropagandaSignal) public propagandaRegistry;

    event ContentFlagged(string contentHash, string narrativeType);

    function flagContent(string memory contentHash, string memory narrativeType, string memory detectionMethod, string memory stewardNote) public {
        propagandaRegistry[contentHash] = PropagandaSignal(contentHash, narrativeType, detectionMethod, true, stewardNote);
        emit ContentFlagged(contentHash, narrativeType);
    }

    function getPropagandaStatus(string memory contentHash) public view returns (PropagandaSignal memory) {
        return propagandaRegistry[contentHash];
    }
}
