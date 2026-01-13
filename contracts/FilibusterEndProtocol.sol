pragma solidity ^0.8.20;

contract FilibusterEndProtocol {
    address public senate;

    struct Action {
        string motion;       // e.g. end filibuster, pass tariff law
        string status;       // e.g. initiated, passed, failed
        uint256 timestamp;
    }

    Action[] public actions;

    event ActionLogged(string motion, string status, uint256 timestamp);

    constructor() { senate = msg.sender; }

    modifier onlySenate() { require(msg.sender == senate, "Not Senate"); _; }

    function logAction(string calldata motion, string calldata status) external onlySenate {
        actions.push(Action(motion, status, block.timestamp));
        emit ActionLogged(motion, status, block.timestamp);
    }

    function totalActions() external view returns (uint256) {
        return actions.length;
    }
}
