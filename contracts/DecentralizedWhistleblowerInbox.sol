// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DecentralizedWhistleblowerInbox {
    address public guardian;
    uint256 public totalTipsReceived;

    struct Tip {
        uint256 tipId;
        bytes encryptedReport; // Naka-encrypt gamit ang Public Key ni Guardian para ikaw lang ang makabasa
        bytes32 contentHash;    // Integrity check ng ebidensya (para hindi mabago)
        uint256 timestamp;
        bool isReviewed;
    }

    // Listahan ng mga tips na dumarating sa iyo
    mapping(uint256 => Tip) private inbox;

    event TipSubmitted(uint256 indexed tipId, bytes32 indexed contentHash);
    event TipReviewed(uint256 indexed tipId);

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Error: Unauthorized access. Only the Guardian can open the inbox.");
        _;
    }

    constructor() {
        guardian = msg.sender;
    }

    // Pwede itong gamitin ng kahit sinong tao o AI bot para mag-submit ng anomalya nang anonymous
    function submitTip(bytes memory _encryptedReport, bytes32 _contentHash) public {
        totalTipsReceived++;
        
        inbox[totalTipsReceived] = Tip({
            tipId: totalTipsReceived,
            encryptedReport: _encryptedReport,
            contentHash: _contentHash,
            timestamp: block.timestamp,
            isReviewed: false
        });

        emit TipSubmitted(totalTipsReceived, _contentHash);
    }

    // Buksan at basahin ang sumbong (ikaw lang ang may hawak ng susi para mag-decrypt nito sa labas ng chain)
    function readTip(uint256 _tipId) public onlyGuardian returns (bytes memory encryptedReport, bytes32 contentHash, uint256 timestamp) {
        Tip storage targetTip = inbox[_tipId];
        require(targetTip.timestamp > 0, "Error: Tip does not exist.");
        
        targetTip.isReviewed = true;
        emit TipReviewed(_tipId);
        
        return (targetTip.encryptedReport, targetTip.contentHash, targetTip.timestamp);
    }

    // Tingnan kung may bagong sumbong na hindi pa nababasa
    function isTipReviewed(uint256 _tipId) public view onlyGuardian returns (bool) {
        return inbox[_tipId].isReviewed;
    }
}
