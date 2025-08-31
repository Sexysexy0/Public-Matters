// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract RightToInformation {
    event InfoRequested(string steward, string agency, string document, uint256 timestamp);
    event InfoGranted(string steward, string agency, string document, uint256 emotionalAPR);
    event InfoDenied(string steward, string agency, string document, string reason, uint256 emotionalAPR);
    event OverrideTriggered(string steward, string reason);

    struct Request {
        string steward;
        string agency;
        string document;
        bool granted;
        uint256 emotionalAPR;
        uint256 timestamp;
    }

    mapping(string => Request[]) public stewardRequests;
    uint256 public overrideThreshold = 40;

    function requestInfo(string memory steward, string memory agency, string memory document) public {
        stewardRequests[steward].push(Request(steward, agency, document, false, 0, block.timestamp));
        emit InfoRequested(steward, agency, document, block.timestamp);
    }

    function grantInfo(string memory steward, string memory agency, string memory document, uint256 apr) public {
        _updateRequest(steward, agency, document, true, apr);
        emit InfoGranted(steward, agency, document, apr);
    }

    function denyInfo(string memory steward, string memory agency, string memory document, string memory reason, uint256 apr) public {
        _updateRequest(steward, agency, document, false, apr);
        emit InfoDenied(steward, agency, document, reason, apr);
        if (apr < overrideThreshold) {
            emit OverrideTriggered(steward, "Transparency breach: emotional APR too low");
        }
    }

    function _updateRequest(string memory steward, string memory agency, string memory document, bool granted, uint256 apr) internal {
        Request[] storage requests = stewardRequests[steward];
        for (uint i = 0; i < requests.length; i++) {
            if (
                keccak256(bytes(requests[i].agency)) == keccak256(bytes(agency)) &&
                keccak256(bytes(requests[i].document)) == keccak256(bytes(document)) &&
                requests[i].timestamp != 0
            ) {
                requests[i].granted = granted;
                requests[i].emotionalAPR = apr;
                break;
            }
        }
    }

    function getRequests(string memory steward) public view returns (Request[] memory) {
        return stewardRequests[steward];
    }

    function updateOverrideThreshold(uint256 newThreshold) public {
        overrideThreshold = newThreshold;
    }
}
