// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

/**
 * @title SonyCreativeResilience
 * @notice Isang on-chain framework para ibalik ang balanse sa pagitan ng PlayStation Studios 
 * at corporate leadership, protektahan ang single-player IPs, at i-audit ang live-service expansion.
 */
contract SonyCreativeResilience {
    
    address public immutable boardExecutive;
    uint256 public liveServiceBudgetCap; // Limit para maiwasan ang pagsasayang ng pondo sa dead-on-arrival games
    uint256 public qualityReviewThreshold;

    mapping(bytes32 => bool) public protectedMasterpieceIPs; // e.g., God of War, Bloodborne, Last of Us

    event IPProtected(bytes32 indexed ipHash);
    event LiveServiceCapUpdated(uint256 newCap);
    event StudioAutonomyGranted(string studioName);

    modifier onlyExecutive() {
        require(msg.sender == boardExecutive, "Unauthorized executive access");
        _;
    }

    constructor(address _boardExecutive, uint256 _initialBudgetCap) {
        boardExecutive = _boardExecutive;
        liveServiceBudgetCap = _initialBudgetCap;
        qualityReviewThreshold = 90; // Mataas na pamantayan para sa PlayStation exclusives
    }

    /**
     * @notice I-lock ang mga narrative IP laban sa pilit na live-service conversion o rushed ports
     */
    function secureMasterpieceIP(string memory _ipName) external onlyExecutive {
        bytes32 ipHash = keccak256(abi.encodePacked(_ipName));
        protectedMasterpieceIPs[ipHash] = true;
        emit IPProtected(ipHash);
    }

    /**
     * @notice Limitahan ang pondo para sa mga mapanganib na live-service projects para protektahan ang pinansyal ng kumpanya
     */
    function adjustLiveServiceCap(uint256 _newCap) external onlyExecutive {
        liveServiceBudgetCap = _newCap;
        emit LiveServiceCapUpdated(_newCap);
    }

    /**
     * @notice Ibalik ang creative freedom sa mga internal studios
     */
    function grantStudioAutonomy(string memory _studioName) external onlyExecutive {
        emit StudioAutonomyGranted(_studioName);
    }
}
