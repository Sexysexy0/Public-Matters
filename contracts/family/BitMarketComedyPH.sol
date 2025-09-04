// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract BitMarketComedyPH {
    address public steward;
    uint256 public jokeFee = 0.01 ether;

    struct ComedyScroll {
        string title;
        string contentHash;
        address performer;
        string emotionalAPR;
        bool isBlessed;
    }

    mapping(uint256 => ComedyScroll) public scrolls;
    uint256 public scrollCount;

    event ScrollDeployed(uint256 indexed scrollId, address indexed performer, string title);
    event BlessingActivated(uint256 indexed scrollId, string emotionalAPR);
    event JokePurchased(address indexed buyer, uint256 indexed scrollId);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function deployScroll(string memory _title, string memory _contentHash) public {
        scrolls[scrollCount] = ComedyScroll({
            title: _title,
            contentHash: _contentHash,
            performer: msg.sender,
            emotionalAPR: "unrated",
            isBlessed: false
        });

        emit ScrollDeployed(scrollCount, msg.sender, _title);
        scrollCount++;
    }

    function blessScroll(uint256 _scrollId, string memory _aprTag) public onlySteward {
        require(_scrollId < scrollCount, "Invalid scroll ID");
        scrolls[_scrollId].emotionalAPR = _aprTag;
        scrolls[_scrollId].isBlessed = true;

        emit BlessingActivated(_scrollId, _aprTag);
    }

    function purchaseJoke(uint256 _scrollId) public payable {
        require(msg.value >= jokeFee, "Insufficient fee");
        require(_scrollId < scrollCount, "Invalid scroll ID");

        emit JokePurchased(msg.sender, _scrollId);
        payable(scrolls[_scrollId].performer).transfer(msg.value);
    }

    function updateFee(uint256 _newFee) public onlySteward {
        jokeFee = _newFee;
    }

    function getScroll(uint256 _scrollId) public view returns (
        string memory title,
        string memory contentHash,
        address performer,
        string memory emotionalAPR,
        bool isBlessed
    ) {
        ComedyScroll memory s = scrolls[_scrollId];
        return (s.title, s.contentHash, s.performer, s.emotionalAPR, s.isBlessed);
    }
}
