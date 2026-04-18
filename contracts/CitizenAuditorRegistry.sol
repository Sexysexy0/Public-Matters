// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CitizenAuditorRegistry {
    struct Investigation {
        address reporter;
        string IPFS_EvidenceHash; // Link to photos/docs on decentralized storage
        uint256 timestamp;
        uint256 validationVotes;
        bool isVerified;
    }

    Investigation[] public publicRecords;
    mapping(address => bool) public isProtectedWhistleblower;

    // Mag-upload ng ebidensya ng fraud nang hindi natatakot sa "Gag Acts"
    function filePublicReport(string memory _evidenceHash) public {
        publicRecords.push(Investigation({
            reporter: msg.sender,
            IPFS_EvidenceHash: _evidenceHash,
            timestamp: block.timestamp,
            validationVotes: 0,
            isVerified: false
        }));
    }

    // Community validation - ang taumbayan ang nag-ve-verify, hindi ang politiko
    function validateReport(uint256 _id) public {
        publicRecords[_id].validationVotes++;
        if(publicRecords[_id].validationVotes >= 100) {
            publicRecords[_id].isVerified = true;
        }
    }
}
