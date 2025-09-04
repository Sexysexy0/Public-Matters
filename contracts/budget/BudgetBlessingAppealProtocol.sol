// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract BudgetBlessingAppealProtocol {
    enum AppealStatus { Pending, Approved, Rejected }

    struct Appeal {
        address submitter;
        string sector;
        string reason;
        AppealStatus status;
    }

    Appeal[] public appeals;
    address public steward;

    event AppealSubmitted(uint256 id, address submitter, string sector);
    event AppealResolved(uint256 id, AppealStatus status);

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function submitAppeal(string memory sector, string memory reason) public {
        appeals.push(Appeal(msg.sender, sector, reason, AppealStatus.Pending));
        emit AppealSubmitted(appeals.length - 1, msg.sender, sector);
    }

    function resolveAppeal(uint256 id, AppealStatus status) public onlySteward {
        require(id < appeals.length, "Invalid appeal ID");
        appeals[id].status = status;
        emit AppealResolved(id, status);
    }

    function getAppeal(uint256 id) public view returns (Appeal memory) {
        require(id < appeals.length, "Invalid appeal ID");
        return appeals[id];
    }
}
