// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SupplyChainPivot {
    enum StraitStatus { Open, Closed, Hostile }

    // [1:15-2:03] Response to IRGC defying political leadership
    function getLogisticsRoute(StraitStatus _status) public pure returns (string memory) {
        if (_status == StraitStatus.Closed || _status == StraitStatus.Hostile) {
            return "ROUTE: Bypass Hormuz. Pivot to Strategic Reserves and alternative pipelines.";
        }
        return "ROUTE: Standard Maritime Passage.";
    }
}
