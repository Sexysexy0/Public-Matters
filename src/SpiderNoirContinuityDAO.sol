// SPDX-License-Identifier: WIZARD-GENESIS-V1
pragma solidity ^0.8.24;

contract SpiderNoirContinuityDAO {
    address public admin;
    bool public active;

    struct Continuation {
        uint256 id;
        string title;
        string story;
        address author;
        uint256 timestamp;
        uint256 votes;
        bool executed;
    }

    struct Episode {
        uint256 id;
        string title;
        string summary;
        string ipfsHash;
        address creator;
        uint256 timestamp;
        bool canonical;
    }

    Continuation[] public continuations;
    Episode[] public episodes;
    mapping(uint256 => mapping(address => bool)) public hasVoted;

    event ContinuationAdded(uint256 indexed id, address author);
    event ContinuationVoted(uint256 indexed id, address voter);
    event EpisodeAdded(uint256 indexed id, address creator);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    modifier whenActive() {
        require(active, "System paused");
        _;
    }

    constructor() {
        admin = msg.sender;
        active = true;
    }

    function addContinuation(string memory _title, string memory _story) public whenActive {
        continuations.push(
            Continuation({
                id: continuations.length,
                title: _title,
                story: _story,
                author: msg.sender,
                timestamp: block.timestamp,
                votes: 0,
                executed: false
            })
        );
        emit ContinuationAdded(continuations.length - 1, msg.sender);
    }

    function voteContinuation(uint256 _id) public whenActive {
        require(_id < continuations.length, "Invalid continuation");
        require(!hasVoted[_id][msg.sender], "Already voted");
        continuations[_id].votes++;
        hasVoted[_id][msg.sender] = true;
        emit ContinuationVoted(_id, msg.sender);
    }

    function addEpisode(string memory _title, string memory _summary, string memory _ipfsHash, address _creator)
        public
        onlyAdmin
        whenActive
    {
        episodes.push(
            Episode({
                id: episodes.length,
                title: _title,
                summary: _summary,
                ipfsHash: _ipfsHash,
                creator: _creator,
                timestamp: block.timestamp,
                canonical: true
            })
        );
        emit EpisodeAdded(episodes.length - 1, _creator);
    }

    function getContinuation(uint256 _id) public view returns (Continuation memory) {
        require(_id < continuations.length, "Invalid continuation");
        return continuations[_id];
    }

    function getEpisodes() public view returns (Episode[] memory) {
        return episodes;
    }

    function toggleActive() public onlyAdmin {
        active = !active;
    }
}
