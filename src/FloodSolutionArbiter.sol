// SPDX-License-Identifier: PUBLIC-MATTERS-V1
pragma solidity 0.8.35;

/**
 * @title FloodSolutionArbiter
 * @author The Source
 * @notice Breaks LGU deadlocks—triggers community referendum if blocked for 90+ days.
 * @dev Uses CitizenVotingDAO for community polling.
 */
contract FloodSolutionArbiter {
    address public admin;
    address public citizenVotingDAO;
    bool public active;
    uint256 public disputeCount;

    struct FloodDispute {
        uint256 id;
        string projectName;
        string description;
        address blockingParty; // LGU or official who blocked
        uint256 proposalDate;
        uint256 blockDate;
        uint256 resolutionDate;
        bool resolved;
        bool communityApproved;
        uint256 referendumId; // Link to CitizenVotingDAO vote
        string notes;
        string ipfsHash;
    }

    mapping(uint256 => FloodDispute) public disputes;
    mapping(address => bool) public isArbiter;

    event DisputeFiled(uint256 indexed id, string projectName, address blocker);
    event DisputeResolved(uint256 indexed id, bool approved);
    event ReferendumTriggered(uint256 indexed disputeId, uint256 referendumId);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    modifier onlyArbiter() {
        require(isArbiter[msg.sender], "Not an arbiter");
        _;
    }

    modifier whenActive() {
        require(active, "System paused");
        _;
    }

    constructor(address _citizenVotingDAO) {
        admin = msg.sender;
        citizenVotingDAO = _citizenVotingDAO;
        active = true;
        disputeCount = 0;
        isArbiter[msg.sender] = true;
    }

    function addArbiter(address _arbiter) public onlyAdmin whenActive {
        isArbiter[_arbiter] = true;
    }

    function removeArbiter(address _arbiter) public onlyAdmin whenActive {
        isArbiter[_arbiter] = false;
    }

    function fileDispute(
        string memory _projectName,
        string memory _description,
        address _blockingParty,
        uint256 _proposalDate,
        uint256 _blockDate,
        string memory _ipfsHash
    ) public onlyArbiter whenActive {
        require(_blockDate > _proposalDate, "Block date must be after proposal");
        // forgefmt: disable-next-line
        // solhint-disable-next-line
        require(_blockDate + 90 days < block.timestamp, "90 days not yet passed");

        uint256 disputeId = disputeCount;
        disputes[disputeId] = FloodDispute({
            id: disputeId,
            projectName: _projectName,
            description: _description,
            blockingParty: _blockingParty,
            proposalDate: _proposalDate,
            blockDate: _blockDate,
            resolutionDate: 0,
            resolved: false,
            communityApproved: false,
            referendumId: 0,
            notes: "",
            ipfsHash: _ipfsHash
        });

        disputeCount++;
        emit DisputeFiled(disputeId, _projectName, _blockingParty);
    }

    function triggerReferendum(uint256 _disputeId) public onlyAdmin whenActive {
        require(_disputeId < disputeCount, "Invalid dispute");
        require(!disputes[_disputeId].resolved, "Already resolved");

        FloodDispute storage d = disputes[_disputeId];

        // Simulate creating referendum via CitizenVotingDAO
        // In production: citizenVotingDAO.createProposal(...)
        uint256 referendumId = block.timestamp; // Placeholder
        d.referendumId = referendumId;

        emit ReferendumTriggered(_disputeId, referendumId);
    }

    function resolveDispute(uint256 _disputeId, bool _approved, string memory _notes) public onlyAdmin whenActive {
        require(_disputeId < disputeCount, "Invalid dispute");
        require(!disputes[_disputeId].resolved, "Already resolved");
        require(disputes[_disputeId].referendumId > 0, "Referendum not triggered");

        FloodDispute storage d = disputes[_disputeId];
        d.resolved = true;
        d.communityApproved = _approved;
        d.resolutionDate = block.timestamp;
        d.notes = _notes;

        emit DisputeResolved(_disputeId, _approved);
    }

    function getDispute(uint256 _disputeId) public view returns (FloodDispute memory) {
        require(_disputeId < disputeCount, "Invalid dispute");
        return disputes[_disputeId];
    }

    function getDisputeCount() public view returns (uint256) {
        return disputeCount;
    }

    function toggleActive() public onlyAdmin {
        active = !active;
    }
}
