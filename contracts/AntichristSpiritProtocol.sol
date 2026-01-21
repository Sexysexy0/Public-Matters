pragma solidity ^0.8.20;

contract AntichristSpiritProtocol {
    address public admin;

    struct Influence {
        string domain;       // e.g. government, judicial system, media
        string effect;       // e.g. suppression of faith, distortion of truth
        uint256 timestamp;
    }

    Influence[] public influences;

    event InfluenceLogged(string domain, string effect, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logInfluence(string calldata domain, string calldata effect) external onlyAdmin {
        influences.push(Influence(domain, effect, block.timestamp));
        emit InfluenceLogged(domain, effect, block.timestamp);
    }

    function totalInfluences() external view returns (uint256) {
        return influences.length;
    }
}
