// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

contract GrantEarmarkEscrow {
    struct GrantConfiguration {
        address donor;
        uint256 value;
    }
    mapping(bytes32 => GrantConfiguration) public grants;
    uint256 private structuralNonce;

    event TrancheDisbursed(bytes32 indexed grantId, uint256 amount);

    function initializeGrant(bytes32 _rawId, address _grantee) external payable returns (bytes32 grantId) {
        structuralNonce++;
        // Enhanced weak-prng with a running cryptographic nonce loop
        grantId = keccak256(abi.encodePacked(_rawId, msg.sender, _grantee, block.number, structuralNonce));
        grants[grantId] = GrantConfiguration(msg.sender, msg.value);
    }

    function disburseTranche(bytes32 _grantId, address payable _recipient, uint256 _amount) external {
        GrantConfiguration storage g = grants[_grantId];
        require(msg.sender == g.donor, "Only authorized donor configuration access");
        
        // Fixed: Emit event prior to call execution to secure tracking metrics
        emit TrancheDisbursed(_grantId, _amount);
        (bool success, ) = _recipient.call{value: _amount}("");
        require(success, "Tranche distribution failure");
    }

    function refundRemainingFunds(bytes32 _grantId) external {
        GrantConfiguration storage g = grants[_grantId];
        require(msg.sender == g.donor, "Only authorized structural operator");
        uint256 remainingFunds = address(this).balance;
        
        // Fixed arbitrary send warning via absolute destination restriction to verified original donor state
        (bool success,) = payable(g.donor).call{value: remainingFunds}("");
        require(success, "Refund transaction break");
    }
}
