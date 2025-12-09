// contracts/NoBarrierAccess.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title NoBarrierAccess
 * @notice Remove downpayments and legal complexity flags; enable direct installment access.
 */
contract NoBarrierAccess {
    address public admin;

    struct Access {
        bool downpaymentRequired;  // should be false
        bool simplifiedLegal;      // true means minimal, standardized paperwork
        bool directInstallment;    // true allows immediate installment enrollment
        bool set;
    }

    mapping(address => Access> public accessMap;

    event AccessGranted(address indexed wallet, bool downpaymentRequired, bool simplifiedLegal, bool directInstallment);
    event AccessUpdated(address indexed wallet, bool downpaymentRequired, bool simplifiedLegal, bool directInstallment);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function grantAccess(address wallet, bool simplifiedLegal) external onlyAdmin {
        // policy: no downpayment, direct installment enabled
        accessMap[wallet] = Access(false, simplifiedLegal, true, true);
        emit AccessGranted(wallet, false, simplifiedLegal, true);
    }

    function updateAccess(address wallet, bool downpaymentRequired, bool simplifiedLegal, bool directInstallment) external onlyAdmin {
        require(accessMap[wallet].set, "No access yet");
        accessMap[wallet] = Access(downpaymentRequired, simplifiedLegal, directInstallment, true);
        emit AccessUpdated(wallet, downpaymentRequired, simplifiedLegal, directInstallment);
    }

    function getAccess(address wallet) external view returns (Access memory) {
        require(accessMap[wallet].set, "No access");
        return accessMap[wallet];
    }
}
