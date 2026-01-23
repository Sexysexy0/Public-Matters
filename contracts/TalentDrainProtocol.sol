pragma solidity ^0.8.20;

contract TalentDrainProtocol {
    address public admin;

    struct Drain {
        string agency;       // e.g. CIA
        string reason;       // e.g. reduced missions, political distrust
        string effect;       // e.g. loss of skilled operatives
        uint256 timestamp;
    }

    Drain[] public drains;

    event DrainLogged(string agency, string reason, string effect, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logDrain(string calldata agency, string calldata reason, string calldata effect) external onlyAdmin {
        drains.push(Drain(agency, reason, effect, block.timestamp));
        emit DrainLogged(agency, reason, effect, block.timestamp);
    }

    function totalDrains() external view returns (uint256) {
        return drains.length;
    }
}
