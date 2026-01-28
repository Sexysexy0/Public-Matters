pragma solidity ^0.8.20;

contract TransparencyProtocol {
    address public admin;

    struct Transparency {
        string actor;        // e.g. AI company, watchdog
        string measure;      // e.g. source disclosure, audit trail
        string effect;       // e.g. trust, accountability
        uint256 timestamp;
    }

    Transparency[] public transparencies;

    event TransparencyLogged(string actor, string measure, string effect, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logTransparency(string calldata actor, string calldata measure, string calldata effect) external onlyAdmin {
        transparencies.push(Transparency(actor, measure, effect, block.timestamp));
        emit TransparencyLogged(actor, measure, effect, block.timestamp);
    }

    function totalTransparencies() external view returns (uint256) {
        return transparencies.length;
    }
}
