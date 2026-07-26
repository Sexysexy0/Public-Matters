// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Anti-Bullshitting Covenant Contract
/// @notice On-chain accountability system against bullshitting, hollow language, and epistemic trespassing.
/// @dev Inspired by Bonhoeffer's "stupidity", Frankfurt's "bullshitting", and Orwell's critique of language.

contract AntiBullshittingCovenant {
    // ============ Enums ============

    enum LanguagePattern {
        None,
        Vague,
        Cliche,
        EpistemicTrespass,
        InverseElitism,
        Groupthink,
        WillfulIgnorance
    }

    enum ClaimStatus {
        Pending,
        Audited,
        Disputed,
        Resolved
    }

    // ============ Structs ============

    struct Claim {
        uint256 id;
        address operator;
        string content;
        uint256 timestamp;
        ClaimStatus status;
        bool truthful;
        address auditor;
        uint256 auditTimestamp;
        uint256 approvalCount;
        uint256 rejectionCount;
    }

    struct Dissent {
        address member;
        string reason;
        LanguagePattern pattern;
        uint256 timestamp;
    }

    struct CouncilMember {
        address member;
        bool active;
        uint256 appointedAt;
    }

    // ============ State Variables ============

    bool public covenantActive;
    uint256 public claimCount;
    uint256 public dissentCount;
    uint256 public constant DISSENT_PERIOD = 7 days;
    uint256 public constant MIN_COUNCIL_SIZE = 3;
    uint256 public requiredApprovals;

    address public founder;

    mapping(uint256 => Claim) public claims;
    mapping(uint256 => Dissent[]) public claimDissents;
    mapping(address => bool) public operators;
    mapping(address => bool) public communityMembers;
    mapping(address => CouncilMember) public councilMembers;
    mapping(address => uint256) public truthfulnessScore;
    mapping(address => uint256) public totalClaims;
    mapping(address => uint256) public truthfulClaims;
    mapping(uint256 => mapping(address => bool)) public hasAudited; // Track who already audited each claim
    
    address[] public councilList;

    // ============ Events ============

    event CovenantInitialized(address indexed founder, uint256 councilSize);
    event ClaimSubmitted(uint256 indexed claimId, address indexed operator, string content);
    event ClaimAudited(uint256 indexed claimId, address indexed auditor, bool truthful);
    event DissentLogged(uint256 indexed claimId, address indexed member, LanguagePattern pattern, string reason);
    event CovenantPaused(address indexed initiator);
    event CovenantResumed(address indexed initiator);
    event OperatorRegistered(address indexed operator);
    event OperatorRemoved(address indexed operator);
    event CommunityMemberRegistered(address indexed member);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);
    event TruthfulnessScoreUpdated(address indexed operator, uint256 newScore);
    event ClaimResolved(uint256 indexed claimId, bool finalTruthfulness);

    // ============ Modifiers ============

    modifier onlyFounder() {
        require(msg.sender == founder, "Not founder");
        _;
    }

    modifier onlyCouncil() {
        require(councilMembers[msg.sender].active, "Not active council member");
        _;
    }

    modifier onlyOperator() {
        require(operators[msg.sender], "Not authorized operator");
        _;
    }

    modifier onlyCommunity() {
        require(communityMembers[msg.sender], "Not authorized community member");
        _;
    }

    modifier whenActive() {
        require(covenantActive, "Covenant inactive");
        _;
    }

    modifier claimExists(uint256 _claimId) {
        require(_claimId > 0 && _claimId <= claimCount, "Claim does not exist");
        _;
    }

    // ============ Constructor ============

    constructor(address[] memory _initialCouncil) {
        require(_initialCouncil.length >= MIN_COUNCIL_SIZE, "Council too small");
        
        founder = msg.sender;
        covenantActive = true;
        requiredApprovals = (_initialCouncil.length / 2) + 1;

        for (uint256 i = 0; i < _initialCouncil.length; i++) {
            address member = _initialCouncil[i];
            require(member != address(0), "Invalid council address");
            require(!councilMembers[member].active, "Duplicate council member");
            
            councilMembers[member] = CouncilMember({
                member: member,
                active: true,
                appointedAt: block.timestamp
            });
            councilList.push(member);
        }

        emit CovenantInitialized(msg.sender, _initialCouncil.length);
    }

    // ============ Registration Functions ============

    function registerOperator(address _op) external onlyCouncil whenActive {
        require(_op != address(0), "Invalid address");
        operators[_op] = true;
        truthfulnessScore[_op] = 50;
        emit OperatorRegistered(_op);
    }

    function removeOperator(address _op) external onlyCouncil whenActive {
        operators[_op] = false;
        emit OperatorRemoved(_op);
    }

    function registerCommunity(address _member) external onlyCouncil whenActive {
        require(_member != address(0), "Invalid address");
        communityMembers[_member] = true;
        emit CommunityMemberRegistered(_member);
    }

    function addCouncilMember(address _member) external onlyFounder whenActive {
        require(_member != address(0), "Invalid address");
        require(!councilMembers[_member].active, "Already council member");
        
        councilMembers[_member] = CouncilMember({
            member: _member,
            active: true,
            appointedAt: block.timestamp
        });
        councilList.push(_member);
        
        uint256 activeCount = getActiveCouncilCount();
        requiredApprovals = (activeCount / 2) + 1;
        
        emit CouncilMemberAdded(_member);
    }

    function removeCouncilMember(address _member) external onlyFounder whenActive {
        require(councilMembers[_member].active, "Not active council member");
        require(getActiveCouncilCount() > MIN_COUNCIL_SIZE, "Cannot reduce below minimum");
        
        councilMembers[_member].active = false;
        
        uint256 activeCount = getActiveCouncilCount();
        requiredApprovals = (activeCount / 2) + 1;
        
        emit CouncilMemberRemoved(_member);
    }

    // ============ Core Functions ============

    function submitClaim(string calldata _content) external onlyOperator whenActive {
        require(bytes(_content).length > 0, "Empty claim");
        require(bytes(_content).length <= 1000, "Claim too long");

        claimCount++;
        
        claims[claimCount] = Claim({
            id: claimCount,
            operator: msg.sender,
            content: _content,
            timestamp: block.timestamp,
            status: ClaimStatus.Pending,
            truthful: false,
            auditor: address(0),
            auditTimestamp: 0,
            approvalCount: 0,
            rejectionCount: 0
        });

        totalClaims[msg.sender]++;

        emit ClaimSubmitted(claimCount, msg.sender, _content);
    }

    function auditClaim(uint256 _claimId, bool _truthful) external onlyCouncil whenActive claimExists(_claimId) {
        Claim storage claim = claims[_claimId];
        require(claim.status != ClaimStatus.Resolved, "Already resolved");
        require(!hasAudited[_claimId][msg.sender], "Already audited by you");

        hasAudited[_claimId][msg.sender] = true;

        if (_truthful) {
            claim.approvalCount++;
        } else {
            claim.rejectionCount++;
        }

        // Check if threshold reached
        if (claim.approvalCount >= requiredApprovals) {
            _finalizeAudit(_claimId, true);
        } else if (claim.rejectionCount >= requiredApprovals) {
            _finalizeAudit(_claimId, false);
        } else {
            claim.status = ClaimStatus.Audited;
            emit ClaimAudited(_claimId, msg.sender, _truthful);
        }
    }

    function logDissent(
        uint256 _claimId, 
        LanguagePattern _pattern, 
        string calldata _reason
    ) external onlyCommunity whenActive claimExists(_claimId) {
        require(bytes(_reason).length > 0, "Empty reason");
        require(bytes(_reason).length <= 500, "Reason too long");
        require(_pattern != LanguagePattern.None, "Must specify pattern");

        Claim storage claim = claims[_claimId];
        require(claim.status != ClaimStatus.Resolved, "Claim already resolved");
        require(block.timestamp <= claim.timestamp + DISSENT_PERIOD, "Dissent period expired");

        dissentCount++;

        claimDissents[_claimId].push(Dissent({
            member: msg.sender,
            reason: _reason,
            pattern: _pattern,
            timestamp: block.timestamp
        }));

        claim.status = ClaimStatus.Disputed;

        emit DissentLogged(_claimId, msg.sender, _pattern, _reason);
    }

    function resolveClaim(uint256 _claimId) external onlyCouncil claimExists(_claimId) {
        Claim storage claim = claims[_claimId];
        require(claim.status == ClaimStatus.Disputed, "Not disputed");
        require(block.timestamp > claim.timestamp + DISSENT_PERIOD, "Deliberation ongoing");

        bool finalTruthfulness = claim.approvalCount > claim.rejectionCount;
        _finalizeAudit(_claimId, finalTruthfulness);
    }

    // ============ Pause / Resume ============

    function pauseCovenant() external onlyFounder {
        covenantActive = false;
        emit CovenantPaused(msg.sender);
    }

    function resumeCovenant() external onlyFounder {
        covenantActive = true;
        emit CovenantResumed(msg.sender);
    }

    // ============ View Functions ============

    function getClaim(uint256 _claimId) external view claimExists(_claimId) returns (Claim memory) {
        return claims[_claimId];
    }

    function getDissents(uint256 _claimId) external view claimExists(_claimId) returns (Dissent[] memory) {
        return claimDissents[_claimId];
    }

    function getTruthfulnessRatio(address _op) external view returns (uint256) {
        if (totalClaims[_op] == 0) return 0;
        return (truthfulClaims[_op] * 100) / totalClaims[_op];
    }

    function getActiveCouncilCount() public view returns (uint256) {
        uint256 count = 0;
        for (uint256 i = 0; i < councilList.length; i++) {
            if (councilMembers[councilList[i]].active) {
                count++;
            }
        }
        return count;
    }

    function getCouncilMembers() external view returns (address[] memory) {
        return councilList;
    }

    // ============ Internal Functions ============

    function _finalizeAudit(uint256 _claimId, bool _truthful) internal {
        Claim storage claim = claims[_claimId];
        
        claim.truthful = _truthful;
        claim.status = ClaimStatus.Resolved;
        claim.auditTimestamp = block.timestamp;

        if (_truthful) {
            truthfulClaims[claim.operator]++;
        }

        uint256 ratio = this.getTruthfulnessRatio(claim.operator);
        truthfulnessScore[claim.operator] = ratio;

        emit ClaimAudited(_claimId, msg.sender, _truthful);
        emit TruthfulnessScoreUpdated(claim.operator, ratio);
        emit ClaimResolved(_claimId, _truthful);
    }
}
