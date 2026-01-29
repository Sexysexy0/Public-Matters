pragma solidity ^0.8.20;

contract AccountabilityGapProtocol {
    address public admin;

    struct Gap {
        string institution;  // e.g. Congress, Agency, Corporation
        string issue;        // e.g. Corruption, Weak oversight
        uint256 timestamp;
    }

    Gap[] public gaps;

    event GapLogged(string institution, string issue, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logGap(string calldata institution, string calldata issue) external onlyAdmin {
        gaps.push(Gap(institution, issue, block.timestamp));
        emit GapLogged(institution, issue, block.timestamp);
    }

    function totalGaps() external view returns (uint256) {
        return gaps.length;
    }
}
