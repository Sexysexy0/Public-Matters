pragma solidity ^0.8.20;

contract TrumpParodyProtocol {
    address public admin;

    struct Parody {
        string character;    // e.g. Homelander
        string inspiration;  // e.g. Donald Trump speeches/actions
        string effect;       // e.g. populist satire, authoritarian critique
        uint256 timestamp;
    }

    Parody[] public parodies;

    event ParodyLogged(string character, string inspiration, string effect, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logParody(string calldata character, string calldata inspiration, string calldata effect) external onlyAdmin {
        parodies.push(Parody(character, inspiration, effect, block.timestamp));
        emit ParodyLogged(character, inspiration, effect, block.timestamp);
    }

    function totalParodies() external view returns (uint256) {
        return parodies.length;
    }
}
