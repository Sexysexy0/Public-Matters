pragma solidity ^0.8.20;

contract CentralBankDismissalProtocol {
    address public admin;

    struct Dismissal {
        string actor;        // e.g. French central bank governor
        string statement;    // e.g. dismiss Bitcoin threat to fiat
        string effect;       // e.g. policy stance, narrative clash
        uint256 timestamp;
    }

    Dismissal[] public dismissals;

    event DismissalLogged(string actor, string statement, string effect, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logDismissal(string calldata actor, string calldata statement, string calldata effect) external onlyAdmin {
        dismissals.push(Dismissal(actor, statement, effect, block.timestamp));
        emit DismissalLogged(actor, statement, effect, block.timestamp);
    }

    function totalDismissals() external view returns (uint256) {
        return dismissals.length;
    }
}
