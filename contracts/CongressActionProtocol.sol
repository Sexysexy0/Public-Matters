pragma solidity ^0.8.20;

contract CongressActionProtocol {
    address public congress;

    struct Action {
        string bill;         // e.g. tariff law, emergency revenue
        string status;       // e.g. introduced, passed, failed
        uint256 timestamp;
    }

    Action[] public actions;

    event ActionLogged(string bill, string status, uint256 timestamp);

    constructor() { congress = msg.sender; }

    modifier onlyCongress() { require(msg.sender == congress, "Not Congress"); _; }

    function logAction(string calldata bill, string calldata status) external onlyCongress {
        actions.push(Action(bill, status, block.timestamp));
        emit ActionLogged(bill, status, block.timestamp);
    }

    function totalActions() external view returns (uint256) {
        return actions.length;
    }
}
