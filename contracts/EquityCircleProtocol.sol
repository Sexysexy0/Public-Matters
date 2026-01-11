pragma solidity ^0.8.20;

contract EquityCircleProtocol {
    address public admin;

    struct Equity {
        string participant;   // e.g. worker, investor, citizen
        uint256 share;        // percentage or token allocation
        uint256 timestamp;
    }

    Equity[] public equities;

    event EquityLogged(string participant, uint256 share, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logEquity(string calldata participant, uint256 share) external onlyAdmin {
        equities.push(Equity(participant, share, block.timestamp));
        emit EquityLogged(participant, share, block.timestamp);
    }

    function totalEquities() external view returns (uint256) {
        return equities.length;
    }
}
