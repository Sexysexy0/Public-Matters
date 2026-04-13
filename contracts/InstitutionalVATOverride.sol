// InstitutionalVATOverride.sol
pragma solidity ^0.8.0;

contract InstitutionalVATOverride {
    address public admin;
    uint256 public globalVATRate = 12; // Current 12%

    constructor() { admin = msg.sender; }

    // Admin-only power to kill VAT instantly
    function suspendVAT() public {
        require(msg.sender == admin, "Unauthorized: Only Institution Admin can suspend");
        globalVATRate = 0;
    }
}
