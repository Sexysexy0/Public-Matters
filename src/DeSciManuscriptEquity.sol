// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

interface ITrustIntegrator {
    function logPositiveAction(address entity, uint256 actionType) external;
}

/**
 * @title DeSciManuscriptEquity
 * @notice On-chain academic manuscript IP registration and automated citation royalty router.
 */
contract DeSciManuscriptEquity {
    address public immutable owner;
    ITrustIntegrator public immutable trustIntegrator;

    struct Manuscript {
        string ipfsCid;
        address author;
        uint256 royaltyFee;
        uint256 totalRoyaltiesEarned;
    }

    mapping(uint256 => Manuscript) public manuscripts;
    uint256 public manuscriptCount;

    event ManuscriptRegistered(uint256 indexed id, string ipfsCid, address indexed author, uint256 royaltyFee);
    event RoyaltyPaid(uint256 indexed id, address indexed subscriber, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner permitted");
        _;
    }

    constructor(address _trustIntegrator) {
        require(_trustIntegrator != address(0), "Invalid integrator address");
        owner = msg.sender;
        trustIntegrator = ITrustIntegrator(_trustIntegrator);
    }

    function registerManuscript(string calldata ipfsCid, address author, uint256 royaltyFee)
        external
        onlyOwner
        returns (uint256 manuscriptId)
    {
        require(author != address(0), "Invalid author address");

        manuscriptId = ++manuscriptCount;
        manuscripts[manuscriptId] =
            Manuscript({ipfsCid: ipfsCid, author: author, royaltyFee: royaltyFee, totalRoyaltiesEarned: 0});

        trustIntegrator.logPositiveAction(author, 4); // 4 = DeSci Scholarly Contribution

        emit ManuscriptRegistered(manuscriptId, ipfsCid, author, royaltyFee);
    }

    function payCitationRoyalty(uint256 manuscriptId) external payable {
        Manuscript storage ms = manuscripts[manuscriptId];
        require(ms.author != address(0), "Manuscript does not exist");
        require(msg.value >= ms.royaltyFee, "Insufficient royalty fee paid");

        ms.totalRoyaltiesEarned += msg.value;

        (bool success,) = payable(ms.author).call{value: msg.value}("");
        require(success, "Royalty transfer failed");

        emit RoyaltyPaid(manuscriptId, msg.sender, msg.value);
    }
}
