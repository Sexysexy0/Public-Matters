// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../contracts/neuroscience/StudyDesignRegistry.sol";
import "../contracts/neuroscience/DataIntegrityLedger.sol";
import "../contracts/neuroscience/AnalysisCodex.sol";
import "../contracts/neuroscience/ReputationToken.sol";
import "../contracts/neuroscience/PeerReviewOracle.sol";

contract NeuroscienceTest is Test {
    StudyDesignRegistry public registry;
    DataIntegrityLedger public ledger;
    AnalysisCodex public codex;
    ReputationToken public token;
    PeerReviewOracle public oracle;

    bytes32 constant STUDY_ID = keccak256("study1");
    bytes32 constant DESIGN_HASH = keccak256("design");
    bytes32 constant HYPOTHESIS = keccak256("hypothesis");
    bytes32 constant DATA_HASH = keccak256("data");
    bytes32 constant CODE_HASH = keccak256("code");
    bytes32 constant PARAMS = keccak256("params");

    function setUp() public {
        registry = new StudyDesignRegistry();
        ledger = new DataIntegrityLedger();
        codex = new AnalysisCodex();
        token = new ReputationToken();
        oracle = new PeerReviewOracle();
    }

    function test_StudyDesignRegistry() public {
        registry.registerStudy(STUDY_ID, DESIGN_HASH, HYPOTHESIS, 100);
        StudyDesignRegistry.Study memory study = registry.getStudy(STUDY_ID);
        assertEq(study.designHash, DESIGN_HASH);
        assertEq(study.hypothesis, HYPOTHESIS);
        assertEq(study.sampleSize, 100);
        assertEq(study.researcher, address(this));
        assertTrue(study.isRegistered);
    }

    function test_DataIntegrityLedger() public {
        bytes32 batchId = keccak256("batch1");
        ledger.uploadDataBatch(batchId, STUDY_ID, DATA_HASH);
        assertTrue(ledger.verifyDataIntegrity(batchId, DATA_HASH));
    }

    function test_AnalysisCodex() public {
        bytes32 analysisId = keccak256("analysis1");
        codex.commitAnalysis(analysisId, STUDY_ID, CODE_HASH, PARAMS);
        (bytes32 codeHash, bytes32 params, bytes32 studyId,, address analyst, bool isVerified) =
            codex.analyses(analysisId);
        assertEq(codeHash, CODE_HASH);
        assertEq(params, PARAMS);
        assertEq(studyId, STUDY_ID);
        assertEq(analyst, address(this));
        assertFalse(isVerified);

        codex.verifyAnalysis(analysisId);
        (,,,,, bool verified) = codex.analyses(analysisId);
        assertTrue(verified);
    }

    function test_ReputationToken() public view {
        // ReputationToken constructor sets name and symbol
        assertEq(token.name(), "ReputationToken");
        assertEq(token.symbol(), "REP");
    }

    function test_PeerReviewOracle() public {
        bytes32 reviewId = keccak256("review1");
        bytes32 reviewHash = keccak256("reviewHash");
        oracle.submitReview(reviewId, STUDY_ID, reviewHash, true);
        assertTrue(oracle.getReplicationStatus(STUDY_ID));
    }
}
