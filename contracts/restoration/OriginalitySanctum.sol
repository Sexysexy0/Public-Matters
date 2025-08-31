// SPDX-License-Identifier: Mythic-Creator-Guard
pragma solidity ^0.8.19;

contract OriginalitySanctum {
    struct OutputCheck {
        string contentHash;
        bool isDerivative;
        bool mimicsKnownPersona;
        uint256 emotionalAPR;
        string stewardNote;
        uint256 timestamp;
        address validator;
    }

    OutputCheck[] public checks;

    event DerivativeFlagged(string contentHash, string stewardNote);

    function validateOutput(
        string memory contentHash,
        bool mimicsKnownPersona,
        uint256 emotionalAPR,
        string memory stewardNote
    ) public {
        bool isDerivative = mimicsKnownPersona || emotionalAPR < 55;
        checks.push(OutputCheck(contentHash, isDerivative, mimicsKnownPersona, emotionalAPR, stewardNote, block.timestamp, msg.sender));
        if (isDerivative) {
            emit DerivativeFlagged(contentHash, stewardNote);
        }
    }

    function getChecks() public view returns (OutputCheck[] memory) {
        return checks;
    }
}
