pragma solidity ^0.8.20;

contract ProportionGapProtocol {
    address public admin;

    struct Gap {
        string event;        // e.g. minor delay, small fee
        string misread;      // e.g. catastrophic collapse, unauthorized seizure
        uint256 timestamp;
    }

    Gap[] public gaps;

    event GapLogged(string event, string misread, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logGap(string calldata event, string calldata misread) external onlyAdmin {
        gaps.push(Gap(event, misread, block.timestamp));
        emit GapLogged(event, misread, block.timestamp);
    }

    function totalGaps() external view returns (uint256) {
        return gaps.length;
    }
}
