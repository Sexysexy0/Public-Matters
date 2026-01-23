pragma solidity ^0.8.20;

contract FuelPriceReliefProtocol {
    address public admin;

    struct Relief {
        string measure;      // e.g. diesel price cut
        string actor;        // e.g. government, oil companies
        string effect;       // e.g. lower transport cost
        uint256 timestamp;
    }

    Relief[] public reliefs;

    event ReliefLogged(string measure, string actor, string effect, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logRelief(string calldata measure, string calldata actor, string calldata effect) external onlyAdmin {
        reliefs.push(Relief(measure, actor, effect, block.timestamp));
        emit ReliefLogged(measure, actor, effect, block.timestamp);
    }

    function totalReliefs() external view returns (uint256) {
        return reliefs.length;
    }
}
