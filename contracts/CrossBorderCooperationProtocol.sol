pragma solidity ^0.8.20;

contract CrossBorderCooperationProtocol {
    address public admin;

    struct Cooperation {
        string partner;      // e.g. China, regional scientists
        string focus;        // e.g. nuclear monitoring, ocean currents
        string outcome;      // e.g. shared data, transparency
        uint256 timestamp;
    }

    Cooperation[] public cooperations;

    event CooperationLogged(string partner, string focus, string outcome, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logCooperation(string calldata partner, string calldata focus, string calldata outcome) external onlyAdmin {
        cooperations.push(Cooperation(partner, focus, outcome, block.timestamp));
        emit CooperationLogged(partner, focus, outcome, block.timestamp);
    }

    function totalCooperations() external view returns (uint256) {
        return cooperations.length;
    }
}
