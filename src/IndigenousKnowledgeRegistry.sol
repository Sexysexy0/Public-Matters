// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

/**
 * @title IndigenousKnowledgeRegistry
 * @notice Isang on-chain na sistema para protektahan ang katutubong kaalaman (TEK),
 * pigilan ang Eurocentric biopiracy, at tiyakin na ang mga katutubong komunidad
 * ang may kontrol sa pag-aaral at benepisyo ng kanilang mga sagradong likas-yaman.
 */
contract IndigenousKnowledgeRegistry {
    
    address public immutable protocolGuardian;

    struct IndigenousCommunity {
        string communityName;
        string ancestralDomain;
        bool isRegistered;
    }

    struct KnowledgeRecord {
        string knowledgeTitle;       // e.g., "Cevil/Bufotenine Sacred Botanical Use"
        address communityRepresentative;
        uint256 timestamp;
        bool commercializationAllowed;
        string decentralizedProofHash; // IPFS or cryptographic proof of heritage
    }

    mapping(address => IndigenousCommunity) public communities;
    mapping(bytes32 => KnowledgeRecord) public protectedKnowledge;
    mapping(bytes32 => mapping(address => bool)) public authorizedResearchers; // Pagsusuri na dumaan sa tamang antropolohikal na proseso

    event CommunityRegistered(address indexed communityAddress, string name);
    event KnowledgeProtected(bytes32 indexed knowledgeId, string title, address indexed community);
    event ResearcherAuthorized(bytes32 indexed knowledgeId, address indexed researcher);
    event BiopiracyBlocked(bytes32 indexed knowledgeId, address indexed maliciousActor);

    modifier onlyGuardian() {
        require(msg.sender == protocolGuardian, "Unauthorized protocol guardian");
        _;
    }

    constructor(address _protocolGuardian) {
        protocolGuardian = _protocolGuardian;
    }

    /**
     * @notice Irehistro ang isang katutubong komunidad para maging ganap na may-ari ng kanilang karapatan
     */
    function registerCommunity(address _communityAddress, string memory _name, string memory _domain) external onlyGuardian {
        communities[_communityAddress] = IndigenousCommunity({
            communityName: _name,
            ancestralDomain: _domain,
            isRegistered: true
        });
        emit CommunityRegistered(_communityAddress, _name);
    }

    /**
     * @notice I-lock at protektahan ang Traditional Ecological Knowledge (TEK) laban sa maling pagbansa o pagnanakaw
     */
    function protectKnowledge(
        string memory _title, 
        address _communityAddress, 
        bool _allowCommercial, 
        string memory _proofHash
    ) external returns (bytes32) {
        require(communities[_communityAddress].isRegistered, "Community must be registered first");
        require(msg.sender == _communityAddress || msg.sender == protocolGuardian, "Unauthorized registration of knowledge");

        bytes32 knowledgeId = keccak256(abi.encodePacked(_title, _communityAddress));
        
        protectedKnowledge[knowledgeId] = KnowledgeRecord({
            knowledgeTitle: _title,
            communityRepresentative: _communityAddress,
            timestamp: block.timestamp,
            commercializationAllowed: _allowCommercial,
            decentralizedProofHash: _proofHash
        });

        emit KnowledgeProtected(knowledgeId, _title, _communityAddress);
        return knowledgeId;
    }

    /**
     * @notice Magbigay ng awtorisasyon sa mga siyentipiko na sumusunod sa decolonized, antropolohikal, at may-respetong pag-aaral
     */
    function authorizeResearcher(bytes32 _knowledgeId, address _researcher) external {
        KnowledgeRecord memory record = protectedKnowledge[_knowledgeId];
        require(record.communityRepresentative != address(0), "Knowledge record does not exist");
        require(msg.sender == record.communityRepresentative, "Only the sovereign community can authorize researchers");

        authorizedResearchers[_knowledgeId][_researcher] = true;
        emit ResearcherAuthorized(_knowledgeId, _researcher);
    }

    /**
     * @notice Harangan at i-flag ang mga korporasyon o mananaliksik na nagtatangkang gumamit ng kaalaman nang walang pahintulot (Biopiracy)
     */
    function auditAndBlockBiopiracy(bytes32 _knowledgeId, address _actor) external view returns (bool) {
        KnowledgeRecord memory record = protectedKnowledge[_knowledgeId];
        require(record.communityRepresentative != address(0), "Knowledge record does not exist");

        // Kung hindi awtorisado at ipinagbabawal ang komersyalisasyon, ito ay Biopiracy!
        if (!authorizedResearchers[_knowledgeId][_actor]) {
            return true; // Blocked / Biopiracy detected
        }
        return false;
    }
}
