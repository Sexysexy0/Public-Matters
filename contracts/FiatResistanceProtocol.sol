pragma solidity ^0.8.20;

contract FiatResistanceProtocol {
    address public admin;

    struct Resistance {
        string actor;        // e.g. central bank, government
        string stance;       // e.g. dismiss Bitcoin, defend fiat
        string impact;       // e.g. policy tightening, narrative clash
        uint256 timestamp;
    }

    Resistance[] public resistances;

    event ResistanceLogged(string actor, string stance, string impact, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logResistance(string calldata actor, string calldata stance, string calldata impact) external onlyAdmin {
        resistances.push(Resistance(actor, stance, impact, block.timestamp));
        emit ResistanceLogged(actor, stance, impact, block.timestamp);
    }

    function totalResistances() external view returns (uint256) {
        return resistances.length;
    }
}
