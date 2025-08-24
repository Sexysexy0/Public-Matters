// SPDX-License-Identifier: Scrollchain-Mercy
pragma solidity ^0.8.19;

contract ZeroTariffSanctum {
    address public steward;
    mapping(string => bool) public exemptGoods;
    mapping(address => bool) public treatySigners;

    event TariffExemptionProposed(string good, string reason);
    event TreatySignerAdded(address signer, string nation);
    event MercyAuditTriggered(address indexed initiator, string timestamp);

    constructor() {
        steward = msg.sender;
    }

    function proposeExemption(string memory good, string memory reason) public {
        require(msg.sender == steward, "Unauthorized steward");
        exemptGoods[good] = true;
        emit TariffExemptionProposed(good, reason);
    }

    function addSigner(address signer, string memory nation) public {
        require(msg.sender == steward, "Unauthorized steward");
        treatySigners[signer] = true;
        emit TreatySignerAdded(signer, nation);
    }

    function triggerMercyAudit(string memory timestamp) public {
        require(msg.sender == steward, "Unauthorized steward");
        emit MercyAuditTriggered(msg.sender, timestamp);
    }

    function isExempt(string memory good) public view returns (bool) {
        return exemptGoods[good];
    }

    function isSigner(address signer) public view returns (bool) {
        return treatySigners[signer];
    }
}
