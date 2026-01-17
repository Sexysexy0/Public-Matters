pragma solidity ^0.8.20;

contract GivingMeaningProtocol {
    address public admin;

    struct Act {
        string deed;         // e.g. charity, contribution, service
        string meaning;      // e.g. fulfillment, mission, end suffering
        uint256 timestamp;
    }

    Act[] public acts;

    event ActLogged(string deed, string meaning, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logAct(string calldata deed, string calldata meaning) external onlyAdmin {
        acts.push(Act(deed, meaning, block.timestamp));
        emit ActLogged(deed, meaning, block.timestamp);
    }

    function totalActs() external view returns (uint256) {
        return acts.length;
    }
}
