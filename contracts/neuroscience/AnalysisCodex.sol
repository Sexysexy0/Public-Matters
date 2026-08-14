// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AnalysisCodex {
    struct Analysis {
        bytes32 codeHash; // Hash ng analysis code
        bytes32 parameters; // Hash ng parameters
        bytes32 studyId;
        uint256 timestamp;
        address analyst;
        bool isVerified;
    }

    mapping(bytes32 => Analysis) public analyses;
    bytes32[] public analysisIds;

    event AnalysisCommitted(bytes32 indexed analysisId, bytes32 indexed studyId);

    function commitAnalysis(
        bytes32 _analysisId,
        bytes32 _studyId,
        bytes32 _codeHash,
        bytes32 _parameters
    ) external {
        require(analyses[_analysisId].analyst == address(0), "Analysis already committed");
        analyses[_analysisId] = Analysis({
            codeHash: _codeHash,
            parameters: _parameters,
            studyId: _studyId,
            timestamp: block.timestamp,
            analyst: msg.sender,
            isVerified: false
        });
        analysisIds.push(_analysisId);
        emit AnalysisCommitted(_analysisId, _studyId);
    }

    function verifyAnalysis(bytes32 _analysisId) external {
        analyses[_analysisId].isVerified = true;
    }
}
