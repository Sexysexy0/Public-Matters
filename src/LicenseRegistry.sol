// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./OperatorPrivileges.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

/**
 * @title LicenseRegistry
 * @notice On-chain representation of the NFT License Agreement.
 *         Handles license acceptance (Amnesty), royalty bypass tracking,
 *         and decentralized amendments (Creator + Majority Voting).
 */
contract LicenseRegistry {
    OperatorPrivileges public immutable privileges;
    IERC721 public immutable nftCollection;

    struct AmendmentProposal {
        bytes32 newLicenseHash;
        uint256 votesFor;
        uint256 votesAgainst;
        bool creatorApproved;
        bool executed;
    }

    bytes32 public currentLicenseHash;
    address public immutable creator;
    uint256 public constant ROYALTY_BPS = 700; // 7% (Animoca style)

    mapping(uint256 => bool) public licenseAccepted; // tokenId => accepted
    mapping(uint256 => mapping(address => bool)) public hasVoted; // proposalId => voter => voted
    mapping(uint256 => AmendmentProposal) public amendments;
    uint256 public amendmentCount;

    event LicenseAccepted(uint256 indexed tokenId, address indexed owner, bytes32 licenseHash);
    event RoyaltyBypassReported(uint256 indexed tokenId, address indexed owner, string marketplace);
    event AmendmentProposed(uint256 indexed proposalId, bytes32 newLicenseHash, address indexed creator);
    event AmendmentVoted(uint256 indexed proposalId, bool support, uint256 totalFor, uint256 totalAgainst);
    event AmendmentExecuted(uint256 indexed proposalId, bytes32 newLicenseHash);

    modifier onlyCreator() {
        require(msg.sender == creator || privileges.isOperator(msg.sender), "Not authorized");
        _;
    }

    constructor(address _privileges, address _nftCollection, bytes32 _initialLicenseHash) {
        require(_privileges != address(0), "privileges=0");
        require(_nftCollection != address(0), "nft=0");
        privileges = OperatorPrivileges(_privileges);
        nftCollection = IERC721(_nftCollection);
        creator = msg.sender;
        currentLicenseHash = _initialLicenseHash;
    }

    /**
     * @notice Section 2: Release & Amnesty. 
     * Holder accepts the license, releasing past liabilities up to this point.
     */
    function acceptLicense(uint256 tokenId) external {
        require(nftCollection.ownerOf(tokenId) == msg.sender, "Not token owner");
        require(!licenseAccepted[tokenId], "Already accepted");

        licenseAccepted[tokenId] = true;
        emit LicenseAccepted(tokenId, msg.sender, currentLicenseHash);
    }

    /**
     * @notice Section 1.3(f): Royalty Enforcement.
     * Reports a holder who circumvented creator fees.
     */
    function reportRoyaltyBypass(uint256 tokenId, string calldata marketplace) external onlyCreator {
        emit RoyaltyBypassReported(tokenId, nftCollection.ownerOf(tokenId), marketplace);
    }

    /**
     * @notice Section 7.7: Amendment by Majority.
     * Step 1: Creator proposes a new hash.
     */
    function proposeAmendment(bytes32 newLicenseHash) external onlyCreator {
        amendmentCount++;
        amendments[amendmentCount] = AmendmentProposal({
            newLicenseHash: newLicenseHash,
            votesFor: 0,
            votesAgainst: 0,
            creatorApproved: true,
            executed: false
        });
        emit AmendmentProposed(amendmentCount, newLicenseHash, msg.sender);
    }

    /**
     * @notice Section 7.7: 1 NFT = 1 Vote.
     * NFT holders vote on the proposed amendment.
     */
    function voteOnAmendment(uint256 proposalId, uint256 tokenId, bool support) external {
        require(nftCollection.ownerOf(tokenId) == msg.sender, "Not token owner");
        require(!hasVoted[proposalId][msg.sender], "Already voted");
        require(!amendments[proposalId].executed, "Already executed");

        hasVoted[proposalId][msg.sender] = true;

        if (support) {
            amendments[proposalId].votesFor++;
        } else {
            amendments[proposalId].votesAgainst++;
        }

        emit AmendmentVoted(proposalId, support, amendments[proposalId].votesFor, amendments[proposalId].votesAgainst);
    }

    /**
     * @notice Executes the amendment if Creator approved and Majority voted YES.
     */
    function executeAmendment(uint256 proposalId) external {
        AmendmentProposal storage a = amendments[proposalId];
        require(a.creatorApproved, "Creator must approve");
        require(a.votesFor > a.votesAgainst, "Majority must approve");
        require(!a.executed, "Already executed");

        a.executed = true;
        currentLicenseHash = a.newLicenseHash;

        emit AmendmentExecuted(proposalId, a.newLicenseHash);
    }
}
