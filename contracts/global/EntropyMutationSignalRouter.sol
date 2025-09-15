// SPDX-License-Identifier: EntropySanctum
pragma solidity ^0.8.19;

contract EntropyMutationSignalRouter {
    struct MutationSignal {
        string binaryHash;
        uint256 entropyScore;
        string mutationType; // e.g., "Polymorphic", "Metamorphic", "AI-Generated"
        bool quarantineTriggered;
        string stewardNote;
    }

    mapping(string => MutationSignal) public signals;

    event MutationTagged(string binaryHash, string mutationType);
    event QuarantineActivated(string binaryHash);

    function tagMutation(string memory binaryHash, uint256 entropyScore, string memory mutationType, string memory stewardNote) public {
        signals[binaryHash] = MutationSignal(binaryHash, entropyScore, mutationType, false, stewardNote);
        emit MutationTagged(binaryHash, mutationType);
    }

    function activateQuarantine(string memory binaryHash) public {
        require(signals[binaryHash].entropyScore >= 7, "Entropy not critical");
        signals[binaryHash].quarantineTriggered = true;
        emit QuarantineActivated(binaryHash);
    }

    function getMutationStatus(string memory binaryHash) public view returns (MutationSignal memory) {
        return signals[binaryHash];
    }
}
