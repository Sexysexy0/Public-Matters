// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IBuyback {
    function verifyAndBuyback(address gardener, uint256 count) external;
}

contract BloomValidator {
    address public admin;
    IBuyback public buybackContract;

    struct ValidationRequest {
        address gardener;
        uint256 potCount;
        string proofHash; // IPFS hash or metadata of photo/video
        bool validated;
    }

    mapping(uint256 => ValidationRequest) public requests;
    uint256 public requestCounter;

    event ValidationRequested(uint256 indexed requestId, address indexed gardener, uint256 potCount);
    event ValidationApproved(uint256 indexed requestId, address indexed gardener);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not scroll-certified");
        _;
    }

    constructor(address _buybackContract) {
        admin = msg.sender;
        buybackContract = IBuyback(_buybackContract);
    }

    function submitValidation(uint256 _potCount, string memory _proofHash) external {
        requests[requestCounter] = ValidationRequest(msg.sender, _potCount, _proofHash, false);
        emit ValidationRequested(requestCounter, msg.sender, _potCount);
        requestCounter++;
    }

    function approveValidation(uint256 _requestId) external onlyAdmin {
        ValidationRequest storage req = requests[_requestId];
        require(!req.validated, "Already validated");

        req.validated = true;
        buybackContract.verifyAndBuyback(req.gardener, req.potCount);

        emit ValidationApproved(_requestId, req.gardener);
    }

    function getRequest(uint256 _requestId) external view returns (ValidationRequest memory) {
        return requests[_requestId];
    }
}
