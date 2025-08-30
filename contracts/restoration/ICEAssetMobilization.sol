// SPDX-License-Identifier: Mythic
pragma solidity ^0.8.19;

contract ICEAssetMobilization {
    struct MobilizationRequest {
        address agent;
        string operationCode;
        string assetType; // e.g., "Navy Ship", "Coast Guard Boat"
        bool emergencyFlag;
        string justification;
        uint timestamp;
    }

    mapping(uint => MobilizationRequest) public requests;
    uint public requestCount;

    event AssetMobilized(
        address indexed agent,
        string operationCode,
        string assetType,
        bool emergencyFlag,
        string justification,
        uint timestamp
    );

    function requestAsset(
        string memory _operationCode,
        string memory _assetType,
        bool _emergencyFlag,
        string memory _justification
    ) public {
        requestCount++;
        requests[requestCount] = MobilizationRequest(
            msg.sender,
            _operationCode,
            _assetType,
            _emergencyFlag,
            _justification,
            block.timestamp
        );

        emit AssetMobilized(
            msg.sender,
            _operationCode,
            _assetType,
            _emergencyFlag,
            _justification,
            block.timestamp
        );
    }

    function getRequest(uint _id) public view returns (MobilizationRequest memory) {
        return requests[_id];
    }
}
