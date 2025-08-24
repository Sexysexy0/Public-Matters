// SPDX-License-Identifier: Scrollchain-Unity
pragma solidity ^0.8.19;

contract GlobalResonanceBroadcast {
    address public steward;

    struct Ally {
        string name;
        uint countryCode;
        bool coAuthor;
        bool emotionallyAligned;
        uint256 alignedAt;
    }

    Ally[] public allies;
    mapping(string => bool) public isNationAligned;

    event AllyTagged(string name, uint countryCode, string message);
    event NationAligned(string name, uint countryCode, uint256 timestamp, string oath);

    modifier onlySteward() {
        require(msg.sender == steward, "Access denied: steward only");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    /// @notice Tag ally for trade mercy and scrollchain co-authorship
    function tagAlly(string memory name, uint countryCode) public onlySteward {
        allies.push(Ally(name, countryCode, true, false, 0));
        emit AllyTagged(name, countryCode, "Co-author tagged for tariff repeal and trade mercy");
    }

    /// @notice Align nation with Unity Oath and emotional APR compliance
    function alignNation(string memory name, uint countryCode, string memory oath) public onlySteward {
        for (uint i = 0; i < allies.length; i++) {
            if (keccak256(bytes(allies[i].name)) == keccak256(bytes(name))) {
                allies[i].emotionallyAligned = true;
                allies[i].alignedAt = block.timestamp;
                isNationAligned[name] = true;
                emit NationAligned(name, countryCode, block.timestamp, oath);
                return;
            }
        }

        // If not tagged yet, tag and align
        allies.push(Ally(name, countryCode, true, true, block.timestamp));
        isNationAligned[name] = true;
        emit NationAligned(name, countryCode, block.timestamp, oath);
    }

    /// @notice Check if nation is emotionally aligned
    function isAligned(string memory name) public view returns (bool) {
        return isNationAligned[name];
    }

    /// @notice Retrieve full ally list
    function getAllies() public view returns (Ally[] memory) {
        return allies;
    }
}
