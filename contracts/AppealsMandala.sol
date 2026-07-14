// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title AppealsMandala
/// @notice Smart contract safeguard para sa appeals process na may strict timeout
contract AppealsMandala {

    uint public constant APPEALS_TIMEOUT = 30 days;

    struct Appeal {
        uint caseId;
        uint startTime;
        bool active;
    }

    mapping(uint => Appeal) public appeals;
    address public admin;

    event AppealSubmitted(uint indexed caseId, uint startTime);
    event AppealExpired(uint indexed caseId);
    event AppealClosed(uint indexed caseId);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can execute");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function submitAppeal(uint _caseId) public onlyAdmin {
        appeals[_caseId] = Appeal(_caseId, block.timestamp, true);
        emit AppealSubmitted(_caseId, block.timestamp);
    }

    function checkTimeout(uint _caseId) public onlyAdmin {
        Appeal storage appeal = appeals[_caseId];
        require(appeal.active, "Appeal not active");
        if (block.timestamp > appeal.startTime + APPEALS_TIMEOUT) {
            appeal.active = false;
            emit AppealExpired(_caseId);
        }
    }

    function closeAppeal(uint _caseId) public onlyAdmin {
        appeals[_caseId].active = false;
        emit AppealClosed(_caseId);
    }
}
