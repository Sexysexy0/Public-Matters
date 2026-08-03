// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title CreatorRoyaltyDistribution
 * @dev Direct Real-Time Royalty Splits & IP Rights Ledger for Independent Creators
 */
contract CreatorRoyaltyDistribution {
    address public rootAdmin;

    struct Contributor {
        address wallet;
        uint256 shareBps; // Share in Basis Points (100 = 1%, 10000 = 100%)
    }

    struct Track {
        string title;
        string ipfsMetadataHash; // Audio/Art Metadata Reference
        address primaryCreator;
        uint256 totalSharesBps;
        bool isActive;
    }

    mapping(uint256 => Track) public tracks;
    mapping(uint256 => Contributor[]) public trackContributors;
    uint256 public trackCount;

    event TrackRegistered(uint256 indexed trackId, string title, address indexed primaryCreator);
    event RoyaltyDistributed(uint256 indexed trackId, address indexed contributor, uint256 amount);

    modifier onlyPrimaryCreator(uint256 _trackId) {
        require(msg.sender == tracks[_trackId].primaryCreator, "CRD: Only primary creator authorized");
        _;
    }

    constructor() {
        rootAdmin = msg.sender;
    }

    function registerTrack(
        string memory _title,
        string memory _ipfsMetadataHash,
        address[] memory _wallets,
        uint256[] memory _sharesBps
    ) external returns (uint256) {
        require(_wallets.length == _sharesBps.length, "CRD: Mismatched input lengths");
        require(_wallets.length > 0, "CRD: Must have at least one contributor");

        uint256 totalShares = 0;
        for (uint256 i = 0; i < _sharesBps.length; i++) {
            totalShares += _sharesBps[i];
        }
        require(totalShares == 10000, "CRD: Total shares must equal 100% (10000 bps)");

        trackCount++;
        tracks[trackCount] = Track({
            title: _title,
            ipfsMetadataHash: _ipfsMetadataHash,
            primaryCreator: msg.sender,
            totalSharesBps: totalShares,
            isActive: true
        });

        for (uint256 i = 0; i < _wallets.length; i++) {
            trackContributors[trackCount].push(Contributor({
                wallet: _wallets[i],
                shareBps: _sharesBps[i]
            }));
        }

        emit TrackRegistered(trackCount, _title, msg.sender);
        return trackCount;
    }

    function payRoyalty(uint256 _trackId) external payable {
        Track memory track = tracks[_trackId];
        require(track.isActive, "CRD: Track is inactive");
        require(msg.value > 0, "CRD: Payment must be greater than zero");

        Contributor[] memory contributors = trackContributors[_trackId];
        for (uint256 i = 0; i < contributors.length; i++) {
            uint256 contributorAmount = (msg.value * contributors[i].shareBps) / 10000;
            if (contributorAmount > 0) {
                (bool success, ) = payable(contributors[i].wallet).call{value: contributorAmount}("");
                require(success, "CRD: Transfer failed");
                emit RoyaltyDistributed(_trackId, contributors[i].wallet, contributorAmount);
            }
        }
    }
}
