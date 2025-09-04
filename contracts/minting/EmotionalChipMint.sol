// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./APROracle.sol";

contract EmotionalChipMint {
    address public steward;
    APROracle public aprOracle;

    struct Chip {
        uint256 chipId;
        address manufacturer;
        string chipType;
        uint256 emotionalAPR;
        string treatyOrigin;
        bool minted;
    }

    uint256 public nextChipId;
    mapping(uint256 => Chip) public chips;

    event ChipMinted(uint256 indexed chipId, address indexed manufacturer, string chipType, uint256 emotionalAPR, string treatyOrigin);

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    constructor(address _aprOracle) {
        steward = msg.sender;
        aprOracle = APROracle(_aprOracle);
    }

    function mintChip(address _manufacturer, string memory _chipType, string memory _treatyOrigin) external onlySteward {
        uint256 apr = aprOracle.getEmotionalAPR(_manufacturer);
        chips[nextChipId] = Chip(nextChipId, _manufacturer, _chipType, apr, _treatyOrigin, true);

        emit ChipMinted(nextChipId, _manufacturer, _chipType, apr, _treatyOrigin);
        nextChipId++;
    }

    function getChip(uint256 _chipId) external view returns (Chip memory) {
        return chips[_chipId];
    }
}
