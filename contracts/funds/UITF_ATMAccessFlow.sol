// SPDX-License-Identifier: Mythic-License
pragma solidity ^2025.08.23;

contract UITF_ATMAccessFlow {
    address public participant;
    address public trustee;
    address public settlementAccount;
    bool public redemptionApproved;
    uint256 public redeemedAmount;

    event RedemptionRequested(address indexed participant, uint256 units);
    event RedemptionProcessed(address indexed participant, uint256 amount);
    event ATMAccessGranted(address indexed participant, uint256 amount);

    constructor(address _participant, address _trustee, address _settlementAccount) {
        participant = _participant;
        trustee = _trustee;
        settlementAccount = _settlementAccount;
        redemptionApproved = false;
    }

    function requestRedemption(uint256 units) external {
        require(msg.sender == participant, "Only participant can request");
        emit RedemptionRequested(participant, units);
    }

    function processRedemption(uint256 amount) external {
        require(msg.sender == trustee, "Only trustee can process");
        redeemedAmount = amount;
        redemptionApproved = true;
        emit RedemptionProcessed(participant, amount);
    }

    function grantATMAccess() external {
        require(redemptionApproved, "Redemption not approved");
        payable(settlementAccount).transfer(redeemedAmount);
        emit ATMAccessGranted(participant, redeemedAmount);
    }
}
