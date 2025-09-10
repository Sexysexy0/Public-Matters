// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ChainOfCustodyRouter {
    struct ClemencyAct {
        string actId;
        address drafter;
        address approver;
        address signer;
        address executor;
        uint256 timestamp;
    }

    mapping(string => ClemencyAct) public clemencyLedger;

    event ClemencyLogged(string actId, address drafter, address approver, address signer, address executor);

    function logClemency(
        string memory actId,
        address drafter,
        address approver,
        address signer,
        address executor
    ) public {
        clemencyLedger[actId] = ClemencyAct(actId, drafter, approver, signer, executor, block.timestamp);
        emit ClemencyLogged(actId, drafter, approver, signer, executor);
    }

    function getClemencyDetails(string memory actId) public view returns (ClemencyAct memory) {
        return clemencyLedger[actId];
    }
}
