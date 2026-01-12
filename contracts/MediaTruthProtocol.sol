pragma solidity ^0.8.20;

contract MediaTruthProtocol {
    address public admin;

    struct Coverage {
        string outlet;       // e.g. mainstream, independent
        string status;       // e.g. fair, biased, blackout
        uint256 timestamp;
    }

    Coverage[] public coverages;

    event CoverageLogged(string outlet, string status, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logCoverage(string calldata outlet, string calldata status) external onlyAdmin {
        coverages.push(Coverage(outlet, status, block.timestamp));
        emit CoverageLogged(outlet, status, block.timestamp);
    }

    function totalCoverages() external view returns (uint256) {
        return coverages.length;
    }
}
