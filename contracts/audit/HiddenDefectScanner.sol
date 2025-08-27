// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract HiddenDefectScanner {
    address public steward;

    struct Defect {
        string item;
        string location;
        string description;
        uint256 timestamp;
        bool isResolved;
    }

    Defect[] public defects;

    event DefectLogged(string item, string location);
    event DefectResolved(string item, string status);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scan attempt.");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function logDefect(string memory item, string memory location, string memory description) public onlySteward {
        defects.push(Defect({
            item: item,
            location: location,
            description: description,
            timestamp: block.timestamp,
            isResolved: false
        }));

        emit DefectLogged(item, location);
    }

    function resolveDefect(uint256 index) public onlySteward {
        require(index < defects.length, "Invalid defect index.");
        defects[index].isResolved = true;
        emit DefectResolved(defects[index].item, "Resolved. Emotional APR restored.");
    }

    function auditDefect(uint256 index) public view returns (string memory) {
        Defect memory d = defects[index];
        return string(abi.encodePacked(
            "Item: ", d.item,
            " | Location: ", d.location,
            " | Description: ", d.description,
            " | Timestamp: ", uint2str(d.timestamp),
            " | Resolved: ", d.isResolved ? "Yes" : "No"
        ));
    }

    function uint2str(uint256 _i) internal pure returns (string memory) {
        if (_i == 0) return "0";
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        while (_i != 0) {
            k = k - 1;
            bstr[k] = bytes1(uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(bstr);
    }
}
