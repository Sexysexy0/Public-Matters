// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./OperatorPrivileges.sol";

/**
 * @title AIAgentCommunicationGuard
 * @notice On-chain log of inter-agent communication; flags unauthorized
 *         channels and unauthorized agent pairs.
 */
contract AIAgentCommunicationGuard {
    OperatorPrivileges public privileges;

    struct Message {
        bytes32 fromAgent;
        bytes32 toAgent;
        bytes32 messageHash;
        uint256 timestamp;
        bool authorized;
    }

    struct Channel {
        bytes32 channelId;
        string name;
        bool authorized;
        uint256 messageCount;
        uint256 createdAt;
    }

    mapping(bytes32 => Channel) internal _channels;
    bytes32[] public channelIds;

    Message[] internal _messages;
    mapping(bytes32 => uint256[]) internal _messagesByAgent;
    mapping(bytes32 => bool) public agentAuthorized;

    uint256 public totalMessages;
    uint256 public totalUnauthorized;

    event ChannelCreated(bytes32 indexed channelId, string name);
    event ChannelAuthorized(bytes32 indexed channelId, bool authorized);
    event AgentAuthorized(bytes32 indexed agentId, bool authorized);
    event MessageLogged(bytes32 indexed fromAgent, bytes32 indexed toAgent, bytes32 messageHash, bool authorized);
    event UnauthorizedCommunication(bytes32 indexed fromAgent, bytes32 indexed toAgent);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "Invalid privileges");
        privileges = OperatorPrivileges(_privileges);
    }

    function createChannel(bytes32 channelId, string calldata name) external onlyOperator {
        require(_channels[channelId].createdAt == 0, "Channel exists");
        _channels[channelId] = Channel({
            channelId: channelId,
            name: name,
            authorized: true,
            messageCount: 0,
            createdAt: block.timestamp
        });
        channelIds.push(channelId);
        emit ChannelCreated(channelId, name);
    }

    function setChannelAuthorized(bytes32 channelId, bool authorized) external onlyOperator {
        require(_channels[channelId].createdAt != 0, "Channel not found");
        _channels[channelId].authorized = authorized;
        emit ChannelAuthorized(channelId, authorized);
    }

    function setAgentAuthorized(bytes32 agentId, bool authorized) external onlyOperator {
        agentAuthorized[agentId] = authorized;
        emit AgentAuthorized(agentId, authorized);
    }

    function logMessage(
        bytes32 fromAgent,
        bytes32 toAgent,
        bytes32 messageHash,
        bytes32 channelId
    ) external onlyOperator {
        bool authorized = agentAuthorized[fromAgent]
            && agentAuthorized[toAgent]
            && _channels[channelId].authorized;

        _messages.push(Message({
            fromAgent: fromAgent,
            toAgent: toAgent,
            messageHash: messageHash,
            timestamp: block.timestamp,
            authorized: authorized
        }));

        uint256 idx = _messages.length - 1;
        _messagesByAgent[fromAgent].push(idx);
        _messagesByAgent[toAgent].push(idx);

        _channels[channelId].messageCount++;
        totalMessages++;

        emit MessageLogged(fromAgent, toAgent, messageHash, authorized);

        if (!authorized) {
            totalUnauthorized++;
            emit UnauthorizedCommunication(fromAgent, toAgent);
        }
    }

    function getMessageCount() external view returns (uint256) {
        return _messages.length;
    }

    function getMessage(uint256 index) external view returns (Message memory) {
        return _messages[index];
    }

    function getMessagesByAgent(bytes32 agentId) external view returns (uint256[] memory) {
        return _messagesByAgent[agentId];
    }

    function totalChannels() external view returns (uint256) {
        return channelIds.length;
    }

    function getChannel(bytes32 channelId) external view returns (Channel memory) {
        return _channels[channelId];
    }
}
