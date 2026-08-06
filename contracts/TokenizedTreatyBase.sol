// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TokenizedTreatyBase
 * @dev Abstract blueprint for on-chain treaty tokenization and governance linking
 */
abstract contract TokenizedTreatyBase {
    
    enum TreatyStatus { DRAFT, SIGNED, ACTIVE, DISPUTE, TERMINATED }

    struct TreatyData {
        string name;                // Official name of the treaty
        string signatories;         // Comma-separated list of involved countries/parties
        uint256 signedAt;           // Timestamp of signing
        TreatyStatus status;        // Current lifecycle status
        uint256 implementationDeadline; // Milestone target date
        bytes32 treatyHash;         // Hash of the physical/digital treaty document
    }

    mapping(uint256 => TreatyData) public treaties;
    uint256 public treatyCount;

    event TreatyCreated(uint256 indexed id, string name, uint256 timestamp);
    event TreatyStatusUpdated(uint256 indexed id, TreatyStatus newStatus);

    modifier onlyActive(uint256 _treatyId) {
        require(treaties[_treatyId].status == TreatyStatus.ACTIVE, "Treaty is not active");
        _;
    }

    function createTreaty(
        string memory _name,
        string memory _signatories,
        bytes32 _treatyHash,
        uint256 _implementationDeadline
    ) public virtual returns (uint256) {
        treatyCount++;
        treaties[treatyCount] = TreatyData({
            name: _name,
            signatories: _signatories,
            signedAt: block.timestamp,
            status: TreatyStatus.DRAFT, // Default to draft
            implementationDeadline: _implementationDeadline,
            treatyHash: _treatyHash
        });
        emit TreatyCreated(treatyCount, _name, block.timestamp);
        return treatyCount;
    }

    function updateStatus(uint256 _treatyId, TreatyStatus _newStatus) public virtual {
        require(treaties[_treatyId].signedAt > 0, "Treaty does not exist");
        treaties[_treatyId].status = _newStatus;
        emit TreatyStatusUpdated(_treatyId, _newStatus);
    }

    function getTreaty(uint256 _id) public view returns (TreatyData memory) {
        return treaties[_id];
    }
}
