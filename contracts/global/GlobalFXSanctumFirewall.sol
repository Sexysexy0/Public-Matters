// SPDX-License-Identifier: GlobalFXSanctumFirewall-License
pragma solidity ^0.8.0;

contract GlobalFXSanctumFirewall {
    address public steward;

    mapping(string => bool) public fxBlocked;

    event FXSignalBlocked(string currency, string reason, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function blockSignal(string memory currency, string memory reason) public {
        require(msg.sender == steward, "Only steward can block");
        fxBlocked[currency] = true;
        emit FXSignalBlocked(currency, reason, block.timestamp);
    }

    function isBlocked(string memory currency) public view returns (bool) {
        return fxBlocked[currency];
    }
}
