pragma solidity ^0.8.20;

contract EchoChamberProtocol {
    address public admin;

    struct Echo {
        string origin;       // e.g. AI model, user community
        string loop;         // e.g. self-training, feedback cycle
        string effect;       // e.g. pollution, reinforcement
        uint256 timestamp;
    }

    Echo[] public echoes;

    event EchoLogged(string origin, string loop, string effect, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logEcho(string calldata origin, string calldata loop, string calldata effect) external onlyAdmin {
        echoes.push(Echo(origin, loop, effect, block.timestamp));
        emit EchoLogged(origin, loop, effect, block.timestamp);
    }

    function totalEchoes() external view returns (uint256) {
        return echoes.length;
    }
}
