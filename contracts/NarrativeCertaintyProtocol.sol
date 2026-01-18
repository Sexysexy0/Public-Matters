pragma solidity ^0.8.20;

contract NarrativeCertaintyProtocol {
    address public admin;

    struct Certainty {
        string narrative;    // e.g. crime conspiracy, collapse
        string level;        // e.g. absolute conviction, refusal to downgrade
        uint256 timestamp;
    }

    Certainty[] public certainties;

    event CertaintyLogged(string narrative, string level, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logCertainty(string calldata narrative, string calldata level) external onlyAdmin {
        certainties.push(Certainty(narrative, level, block.timestamp));
        emit CertaintyLogged(narrative, level, block.timestamp);
    }

    function totalCertainties() external view returns (uint256) {
        return certainties.length;
    }
}
