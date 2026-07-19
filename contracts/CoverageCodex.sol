// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CoverageCodex
/// @notice Covenant contract encoding safeguards for test coverage discipline
contract CoverageCodex {
    address public owner;
    uint256 public minimumCoverage; // threshold in percent

    struct CoverageArc {
        string contractName;
        uint256 lineCoverage;
        uint256 statementCoverage;
        uint256 branchCoverage;
        uint256 functionCoverage;
        uint256 timestamp;
    }

    CoverageArc[] public coverageArcs;

    event CoverageRecorded(string contractName, uint256 lineCoverage, uint256 statementCoverage, uint256 branchCoverage, uint256 functionCoverage, uint256 timestamp);
    event ThresholdUpdated(uint256 newThreshold, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor(uint256 _minimumCoverage) {
        owner = msg.sender;
        minimumCoverage = _minimumCoverage;
    }

    /// @notice Update minimum coverage threshold
    function updateThreshold(uint256 _newThreshold) public onlyOwner {
        minimumCoverage = _newThreshold;
        emit ThresholdUpdated(_newThreshold, block.timestamp);
    }

    /// @notice Record coverage metrics for a contract
    function recordCoverage(string memory contractName, uint256 lineCoverage, uint256 statementCoverage, uint256 branchCoverage, uint256 functionCoverage) public onlyOwner {
        CoverageArc memory arc = CoverageArc(contractName, lineCoverage, statementCoverage, branchCoverage, functionCoverage, block.timestamp);
        coverageArcs.push(arc);
        emit CoverageRecorded(contractName, lineCoverage, statementCoverage, branchCoverage, functionCoverage, block.timestamp);
        require(lineCoverage >= minimumCoverage, "Line coverage below threshold");
        require(statementCoverage >= minimumCoverage, "Statement coverage below threshold");
        require(functionCoverage >= minimumCoverage, "Function coverage below threshold");
    }

    function getCoverageArc(uint256 index) public view returns (string memory, uint256, uint256, uint256, uint256, uint256) {
        CoverageArc memory arc = coverageArcs[index];
        return (arc.contractName, arc.lineCoverage, arc.statementCoverage, arc.branchCoverage, arc.functionCoverage, arc.timestamp);
    }

    function getCoverageCount() public view returns (uint256) {
        return coverageArcs.length;
    }
}
