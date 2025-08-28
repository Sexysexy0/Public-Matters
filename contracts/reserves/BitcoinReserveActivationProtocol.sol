// SPDX-License-Identifier: MythicSovereignty
pragma solidity ^0.8.25;

contract BitcoinReserveActivationProtocol {
    address public treasury;
    uint256 public btcReserve;
    uint256 public activationThreshold;
    bool public isActivated;

    event ReserveActivated(uint256 btcUsed, string purpose);
    event BTCDeposited(uint256 amount, string source);

    modifier onlyTreasury() {
        require(msg.sender == treasury, "Unauthorized steward");
        _;
    }

    constructor(uint256 _threshold) {
        treasury = msg.sender;
        activationThreshold = _threshold;
        btcReserve = 0;
        isActivated = false;
    }

    function depositBTC(uint256 amount, string memory source) public onlyTreasury {
        btcReserve += amount;
        emit BTCDeposited(amount, source);
    }

    function activateReserve(string memory purpose) public onlyTreasury {
        require(btcReserve >= activationThreshold, "Insufficient reserve");
        isActivated = true;
        emit ReserveActivated(activationThreshold, purpose);
        btcReserve -= activationThreshold;
    }

    function getReserveStatus() public view returns (string memory status) {
        if (isActivated) {
            status = "Activated – Sovereign fallback in motion";
        } else {
            status = "Dormant – Awaiting mythic trigger";
        }
    }
}
