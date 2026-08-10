// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract YellowMaskProtocol {
    address public curator;
    uint256 public maskCount;

    struct MaskEntry {
        uint256 id;
        address submitter;
        string interpretation;
        uint256 timestamp;
    }

    mapping(uint256 => MaskEntry) public masks;

    event MaskAdded(uint256 indexed id, address indexed submitter, string interpretation);

    modifier onlyCurator() {
        require(msg.sender == curator, "Only curator");
        _;
    }

    constructor() {
        curator = msg.sender;
    }

    function addMask(string calldata _interpretation) external returns (uint256) {
        maskCount++;
        masks[maskCount] = MaskEntry(maskCount, msg.sender, _interpretation, block.timestamp);
        emit MaskAdded(maskCount, msg.sender, _interpretation);
        return maskCount;
    }

    function updateCurator(address _newCurator) external onlyCurator {
        curator = _newCurator;
    }
}
