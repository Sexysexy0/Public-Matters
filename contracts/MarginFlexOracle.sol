// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract MarginFlexOracle is Ownable {

    constructor() Ownable(msg.sender) {}

    event FlexRecord(string company, string policy);

    function logFlex(string memory _company, string memory _policy) external {
        emit FlexRecord(_company, _policy);
        // ORACLE: Margin flexibility logged for governance.
    }
}
