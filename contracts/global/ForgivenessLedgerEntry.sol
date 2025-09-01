// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ForgivenessLedgerEntry {
    struct ForgivenessAct {
        address initiator;
        address recipient;
        string reason;
        string gesture;
        uint256 emotionalAPR;
        uint256 timestamp;
        bool forgiven;
    }

    ForgivenessAct[] public ledger;

    event ForgivenessLogged(
        address indexed initiator,
        address indexed recipient,
        string reason,
        string gesture,
        uint256 emotionalAPR,
        uint256 timestamp,
        bool forgiven
    );

    function logForgiveness(
        address _recipient,
        string memory _reason,
        string memory _gesture,
        uint256 _emotionalAPR
    ) public {
        bool isForgiven = _emotionalAPR >= 75; // Ritual threshold for genuine forgiveness
        uint256 time = block.timestamp;

        ledger.push(ForgivenessAct(
            msg.sender,
            _recipient,
            _reason,
            _gesture,
            _emotionalAPR,
            time,
            isForgiven
        ));

        emit ForgivenessLogged(
            msg.sender,
            _recipient,
            _reason,
            _gesture,
            _emotionalAPR,
            time,
            isForgiven
        );
    }

    function getAllEntries() public view returns (ForgivenessAct[] memory) {
        return ledger;
    }
}
