// SPDX-License-Identifier: SuccessionSanctum
pragma solidity ^0.8.19;

contract ProtocolSuccessionRouter {
    struct SuccessionSignal {
        address protocolID;
        string protocolName;
        address successorDAO;
        uint256 successionDate;
        bool verified;
        string stewardNote;
    }

    mapping(address => SuccessionSignal) public successionRegistry;

    event ProtocolTagged(address protocolID, address successorDAO);
    event ProtocolVerified(address protocolID);

    function tagSuccession(address protocolID, string memory protocolName, address successorDAO, uint256 successionDate, string memory stewardNote) public {
        successionRegistry[protocolID] = SuccessionSignal(protocolID, protocolName, successorDAO, successionDate, false, stewardNote);
        emit ProtocolTagged(protocolID, successorDAO);
    }

    function verifySuccession(address protocolID) public {
        require(bytes(successionRegistry[protocolID].protocolName).length > 0, "Protocol not tagged");
        successionRegistry[protocolID].verified = true;
        emit ProtocolVerified(protocolID);
    }

    function getSuccessionStatus(address protocolID) public view returns (SuccessionSignal memory) {
        return successionRegistry[protocolID];
    }
}
