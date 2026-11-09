// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./OperatorPrivileges.sol";

contract ITServiceRequestRegistry {
    OperatorPrivileges public immutable privileges;

    enum TicketType { INCIDENT, SERVICE_REQUEST }
    enum TicketStatus { OPEN, IN_PROGRESS, RESOLVED, CLOSED }

    struct Ticket {
        bytes32 id;
        TicketType tType;
        TicketStatus status;
        address requester;
        address assignedTo;
        bytes32 detailsHash; // IPFS hash or metadata
        bytes32 resolutionHash; // Cryptographic proof of resolution
        uint256 createdAt;
        uint256 resolvedAt;
    }

    mapping(bytes32 => Ticket) public tickets;
    mapping(address => bytes32[]) public ticketsByRequester;
    mapping(address => bytes32[]) public ticketsByAssignee;
    uint256 public totalTickets;

    event TicketCreated(bytes32 indexed id, TicketType indexed tType, address indexed requester);
    event TicketAssigned(bytes32 indexed id, address indexed assignee);
    event TicketResolved(bytes32 indexed id, bytes32 resolutionHash);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "privileges=0");
        privileges = OperatorPrivileges(_privileges);
    }

    function createTicket(TicketType tType, bytes32 detailsHash) external returns (bytes32) {
        bytes32 id = keccak256(abi.encodePacked(msg.sender, detailsHash, block.timestamp, totalTickets));
        require(tickets[id].createdAt == 0, "Ticket exists");

        totalTickets++;
        tickets[id] = Ticket({
            id: id,
            tType: tType,
            status: TicketStatus.OPEN,
            requester: msg.sender,
            assignedTo: address(0),
            detailsHash: detailsHash,
            resolutionHash: bytes32(0),
            createdAt: block.timestamp,
            resolvedAt: 0
        });

        ticketsByRequester[msg.sender].push(id);
        emit TicketCreated(id, tType, msg.sender);
        return id;
    }

    function assignTicket(bytes32 ticketId, address assignee) external onlyOperator {
        Ticket storage t = tickets[ticketId];
        require(t.status == TicketStatus.OPEN, "Ticket not open");
        t.status = TicketStatus.IN_PROGRESS;
        t.assignedTo = assignee;
        ticketsByAssignee[assignee].push(ticketId);
        emit TicketAssigned(ticketId, assignee);
    }

    function resolveTicket(bytes32 ticketId, bytes32 resolutionHash) external onlyOperator {
        Ticket storage t = tickets[ticketId];
        require(t.status == TicketStatus.IN_PROGRESS, "Ticket not in progress");
        t.status = TicketStatus.RESOLVED;
        t.resolutionHash = resolutionHash;
        t.resolvedAt = block.timestamp;
        emit TicketResolved(ticketId, resolutionHash);
    }
}
