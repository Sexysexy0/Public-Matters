pragma solidity ^0.8.20;

contract FaithManipulationProtocol {
    address public admin;

    struct Faith {
        string character;    // e.g. Homelander, Ezekiel
        string tactic;       // e.g. religion as marketing, faith exploitation
        string effect;       // e.g. mass manipulation, follower gain
        uint256 timestamp;
    }

    Faith[] public faiths;

    event FaithLogged(string character, string tactic, string effect, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logFaith(string calldata character, string calldata tactic, string calldata effect) external onlyAdmin {
        faiths.push(Faith(character, tactic, effect, block.timestamp));
        emit FaithLogged(character, tactic, effect, block.timestamp);
    }

    function totalFaiths() external view returns (uint256) {
        return faiths.length;
    }
}
