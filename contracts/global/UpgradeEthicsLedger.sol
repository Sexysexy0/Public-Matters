// SPDX-License-Identifier: UpgradeSanctum
pragma solidity ^0.8.19;

contract UpgradeEthicsLedger {
    struct UpgradeAudit {
        string upgradeName;
        string leadDeveloper;
        string activationDate;
        string promisedFeatures;
        string actualOutcome;
        bool socialAttackSurfaceTagged;
        bool ethicalReviewComplete;
        string stewardNote;
    }

    mapping(bytes32 => UpgradeAudit) public audits;

    event UpgradeTagged(string upgradeName, string leadDeveloper);
    event EthicalReviewCompleted(string upgradeName);

    function tagUpgrade(string memory upgradeName, string memory leadDeveloper, string memory activationDate, string memory promisedFeatures, string memory actualOutcome, string memory stewardNote) public {
        bytes32 auditId = keccak256(abi.encodePacked(upgradeName, activationDate, block.timestamp));
        audits[auditId] = UpgradeAudit(upgradeName, leadDeveloper, activationDate, promisedFeatures, actualOutcome, false, false, stewardNote);
        emit UpgradeTagged(upgradeName, leadDeveloper);
    }

    function tagSocialAttackSurface(string memory upgradeName, string memory activationDate) public {
        bytes32 auditId = keccak256(abi.encodePacked(upgradeName, activationDate, block.timestamp));
        audits[auditId].socialAttackSurfaceTagged = true;
    }

    function completeEthicalReview(string memory upgradeName, string memory activationDate) public {
        bytes32 auditId = keccak256(abi.encodePacked(upgradeName, activationDate, block.timestamp));
        audits[auditId].ethicalReviewComplete = true;
        emit EthicalReviewCompleted(upgradeName);
    }

    function getUpgradeStatus(string memory upgradeName, string memory activationDate) public view returns (UpgradeAudit memory) {
        bytes32 auditId = keccak256(abi.encodePacked(upgradeName, activationDate, block.timestamp));
        return audits[auditId];
    }
}
