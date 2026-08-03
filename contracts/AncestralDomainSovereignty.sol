// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title AncestralDomainSovereignty
 * @dev Cryptographic Protection & Mandatory FPIC Multi-Sig Consensus for Ancestral Lands
 */
contract AncestralDomainSovereignty {
    address public rootAdmin;

    struct AncestralZone {
        string zoneName;
        string geoHashLocation; // GPS/Boundary Data Reference
        bool isProtected;
        uint256 requiredSignatures; // Required Tribal Elders for Consensus
        uint256 totalElders;
    }

    struct ProjectProposal {
        uint256 zoneId;
        string developerName;
        string proposalURI;
        uint256 approvalCount;
        bool isApproved;
        bool isVetoed;
    }

    mapping(uint256 => AncestralZone) public zones;
    mapping(uint256 => mapping(address => bool)) public isTribalElder;
    mapping(uint256 => ProjectProposal) public proposals;
    mapping(uint256 => mapping(address => bool)) public proposalVotes;

    uint256 public zoneCount;
    uint256 public proposalCount;

    event ZoneRegistered(uint256 indexed zoneId, string zoneName, string geoHashLocation);
    event ProposalCreated(uint256 indexed proposalId, uint256 indexed zoneId, string developerName);
    event VoteCast(uint256 indexed proposalId, address indexed elder, bool approved);
    event FPICGranted(uint256 indexed proposalId, uint256 indexed zoneId);
    event ProjectVetoed(uint256 indexed proposalId, uint256 indexed zoneId);

    modifier onlyAdmin() {
        require(msg.sender == rootAdmin, "ADS: Only Root Admin authorized");
        _;
    }

    modifier onlyElder(uint256 _zoneId) {
        require(isTribalElder[_zoneId][msg.sender], "ADS: Only verified Tribal Elder can vote");
        _;
    }

    constructor() {
        rootAdmin = msg.sender;
    }

    function registerAncestralZone(
        string memory _zoneName,
        string memory _geoHashLocation,
        address[] memory _elders,
        uint256 _requiredSignatures
    ) external onlyAdmin {
        require(_requiredSignatures <= _elders.length && _requiredSignatures > 0, "ADS: Invalid signature threshold");
        
        zoneCount++;
        zones[zoneCount] = AncestralZone({
            zoneName: _zoneName,
            geoHashLocation: _geoHashLocation,
            isProtected: true,
            requiredSignatures: _requiredSignatures,
            totalElders: _elders.length
        });

        for (uint256 i = 0; i < _elders.length; i++) {
            isTribalElder[zoneCount][_elders[i]] = true;
        }

        emit ZoneRegistered(zoneCount, _zoneName, _geoHashLocation);
    }

    function submitProjectProposal(
        uint256 _zoneId,
        string memory _developerName,
        string memory _proposalURI
    ) external returns (uint256) {
        require(zones[_zoneId].isProtected, "ADS: Zone is not protected");

        proposalCount++;
        proposals[proposalCount] = ProjectProposal({
            zoneId: _zoneId,
            developerName: _developerName,
            proposalURI: _proposalURI,
            approvalCount: 0,
            isApproved: false,
            isVetoed: false
        });

        emit ProposalCreated(proposalCount, _zoneId, _developerName);
        return proposalCount;
    }

    function castFPICVote(uint256 _proposalId, bool _approve) external onlyElder(proposals[_proposalId].zoneId) {
        ProjectProposal storage proposal = proposals[_proposalId];
        require(!proposal.isApproved && !proposal.isVetoed, "ADS: Proposal resolution complete");
        require(!proposalVotes[_proposalId][msg.sender], "ADS: Vote already recorded");

        proposalVotes[_proposalId][msg.sender] = true;

        if (_approve) {
            proposal.approvalCount++;
            emit VoteCast(_proposalId, msg.sender, true);

            if (proposal.approvalCount >= zones[proposal.zoneId].requiredSignatures) {
                proposal.isApproved = true;
                emit FPICGranted(_proposalId, proposal.zoneId);
            }
        } else {
            proposal.isVetoed = true;
            emit ProjectVetoed(_proposalId, proposal.zoneId);
        }
    }
}
