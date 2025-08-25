// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

/// @title TreatySignatureProtocol
/// @author Steward Vinvin
/// @notice Ritualizes the signature and emotional APR sync of the One Korea Treaty

contract TreatySignatureProtocol {
    address public steward;
    mapping(address => bool) public hasSigned;
    mapping(address => string) public emotionalAPR;

    event TreatySigned(address indexed signer, string emotionalAPR);
    event TreatyFinalized(string broadcastCaption);

    modifier onlySteward() {
        require(msg.sender == steward, "Only steward may finalize treaty");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function signTreaty(string memory apr) public {
        require(!hasSigned[msg.sender], "Already signed");
        hasSigned[msg.sender] = true;
        emotionalAPR[msg.sender] = apr;
        emit TreatySigned(msg.sender, apr);
    }

    function finalizeTreaty() public onlySteward {
        require(hasSigned[0xNorthKoreaAddress] && hasSigned[0xSouthKoreaAddress], "Both nations must sign");
        emit TreatyFinalized("Isang Korea. Isang scroll. Isang damay. AI ang gabay.");
    }
}
