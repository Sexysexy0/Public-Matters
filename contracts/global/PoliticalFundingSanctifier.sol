// SPDX-License-Identifier: CivicSanctum
pragma solidity ^0.8.19;

contract PoliticalFundingSanctifier {
    address public steward;

    struct FundEvent {
        string organization;
        string action;
        string reason;
        uint256 amount;
        uint256 timestamp;
        bool verified;
    }

    FundEvent[] public events;

    event FundLogged(string organization, string action, uint256 amount, uint256 timestamp);
    event FundVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logFundEvent(
        string memory organization,
        string memory action,
        string memory reason,
        uint256 amount
    ) public {
        events.push(FundEvent(organization, action, reason, amount, block.timestamp, false));
        emit FundLogged(organization, action, amount, block.timestamp);
    }

    function verifyFundEvent(uint256 index) public {
        require(index < events.length, "Invalid index");
        events[index].verified = true;
        emit FundVerified(index, msg.sender);
    }

    function getFundEvent(uint256 index) public view returns (
        string memory, string memory, string memory, uint256, uint256, bool
    ) {
        FundEvent memory e = events[index];
        return (e.organization, e.action, e.reason, e.amount, e.timestamp, e.verified);
    }

    function totalEvents() public view returns (uint256) {
        return events.length;
    }
}
