// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract CivicIntegrityPurgeProtocol {
    address public steward;

    struct Employee {
        string name;
        bool isFlagged;
        bool isPresent;
        uint256 corruptionScore;
        bool isRerouted;
    }

    mapping(address => Employee) public employees;
    event EmployeeFlagged(string name, uint256 score, string status);
    event EmployeeRerouted(string name, string reason);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized purge attempt.");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function auditEmployee(address empAddr, string memory name, uint256 corruptionScore) public onlySteward {
        bool flag = corruptionScore >= 70;
        employees[empAddr] = Employee({
            name: name,
            isFlagged: flag,
            isPresent: true,
            corruptionScore: corruptionScore,
            isRerouted: false
        });

        string memory status = flag ? "Flagged for reroute. Damay clause revoked." : "Clean. Civic resonance intact.";
        emit EmployeeFlagged(name, corruptionScore, status);
    }

    function rerouteEmployee(address empAddr) public onlySteward {
        require(employees[empAddr].isFlagged, "Employee not flagged.");
        employees[empAddr].isRerouted = true;
        emit EmployeeRerouted(employees[empAddr].name, "Rerouted to non-sensitive post. Budget sanctum protected.");
    }

    function auditStatus(address empAddr) public view returns (string memory) {
        Employee memory e = employees[empAddr];
        return string(abi.encodePacked(
            "Name: ", e.name,
            " | Corruption Score: ", uint2str(e.corruptionScore),
            " | Flagged: ", e.isFlagged ? "Yes" : "No",
            " | Rerouted: ", e.isRerouted ? "Yes" : "No"
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
