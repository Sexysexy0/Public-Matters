pragma solidity ^0.8.20;

contract IntuitionLackProtocol {
    address public admin;

    struct Gap {
        string context;      // e.g. harmless delay, small fee
        string misread;      // e.g. catastrophic collapse, unauthorized seizure
        uint256 timestamp;
    }

    Gap[] public gaps;

    event GapLogged(string context, string misread, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logGap(string calldata context, string calldata misread) external onlyAdmin {
        gaps.push(Gap(context, misread, block.timestamp));
        emit GapLogged(context, misread, block.timestamp);
    }

    function totalGaps() external view returns (uint256) {
        return gaps.length;
    }
}
