pragma solidity ^0.8.20;

contract TimingInvestmentProtocol {
    address public admin;

    struct Timing {
        string phase;        // e.g. early adoption, late rollout
        string effect;       // e.g. losses, delayed profitability
        string outlook;      // e.g. long-term gains, short-term hype
        uint256 timestamp;
    }

    Timing[] public timings;

    event TimingLogged(string phase, string effect, string outlook, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logTiming(string calldata phase, string calldata effect, string calldata outlook) external onlyAdmin {
        timings.push(Timing(phase, effect, outlook, block.timestamp));
        emit TimingLogged(phase, effect, outlook, block.timestamp);
    }

    function totalTimings() external view returns (uint256) {
        return timings.length;
    }
}
