// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IAuditHistory.sol";

contract JudiciaryWelfareVault {
    address public guardianWallet;
    IAuditHistory public auditHistory;
    uint256 public minimalContribution;

    struct WelfareClaim {
        uint256 id;
        address claimant;
        uint256 amount;
        bytes32 medicalHash;
        bool approved;
        bool settled;
    }

    mapping(uint256 => WelfareClaim) public claims;
    uint256 public totalClaims;

    event ClaimFiled(uint256 indexed id, address indexed claimant, uint256 amount);
    event ClaimSettled(uint256 indexed id, address indexed claimant, uint256 amount);

    constructor(uint256 _minimalContribution) {
        guardianWallet = msg.sender;
        minimalContribution = _minimalContribution;
    }

    function setAuditHistoryAddress(address _auditHistoryAddress) public {
        require(msg.sender == guardianWallet, "Only guardian can set audit history");
        auditHistory = IAuditHistory(_auditHistoryAddress);
    }

    function depositContribution() public payable {
        require(msg.value >= minimalContribution, "Contribution too low");
    }

    function activeCoverage(address _staff) public pure returns (bool) {
        // simplified for demo, always true
        return true;
    }

    function fileWelfareClaim(uint256 _amount, bytes32 _medicalHash) public returns (uint256) {
        totalClaims++;
        claims[totalClaims] = WelfareClaim({
            id: totalClaims,
            claimant: msg.sender,
            amount: _amount,
            medicalHash: _medicalHash,
            approved: true,
            settled: false
        });
        emit ClaimFiled(totalClaims, msg.sender, _amount);
        return totalClaims;
    }

    function settleWelfareClaim(uint256 _claimId) public {
        WelfareClaim storage c = claims[_claimId];
        require(!c.settled, "Already settled");
        c.settled = true;

        (bool success, ) = payable(c.claimant).call{value: c.amount}("");
        require(success, "Transfer failed");

        emit ClaimSettled(_claimId, c.claimant, c.amount);
    }

    // Allow contract to accept Ether funding
    receive() external payable {}
}
