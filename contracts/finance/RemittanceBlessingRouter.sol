// SPDX-License-Identifier: DiasporaSanctum
pragma solidity ^0.8.19;

contract RemittanceBlessingRouter {
    struct RemittanceFlow {
        string senderName;
        string originCountry;
        string destinationCountry;
        uint256 amount;
        bool corridorBlessed;
        bool dignityCertified;
    }

    mapping(bytes32 => RemittanceFlow) public flows;

    event RemittanceLogged(
        string senderName,
        string originCountry,
        string destinationCountry,
        uint256 amount
    );

    event CorridorBlessed(string originCountry, string destinationCountry);
    event DignityCertified(string senderName);

    function logRemittance(
        string memory senderName,
        string memory originCountry,
        string memory destinationCountry,
        uint256 amount
    ) public {
        bytes32 flowId = keccak256(abi.encodePacked(senderName, originCountry, destinationCountry, amount));
        flows[flowId] = RemittanceFlow(senderName, originCountry, destinationCountry, amount, false, false);
        emit RemittanceLogged(senderName, originCountry, destinationCountry, amount);
    }

    function blessCorridor(string memory originCountry, string memory destinationCountry) public {
        bytes32 flowId = keccak256(abi.encodePacked(originCountry, destinationCountry));
        flows[flowId].corridorBlessed = true;
        emit CorridorBlessed(originCountry, destinationCountry);
    }

    function certifyDignity(string memory senderName, string memory originCountry, string memory destinationCountry, uint256 amount) public {
        bytes32 flowId = keccak256(abi.encodePacked(senderName, originCountry, destinationCountry, amount));
        require(flows[flowId].corridorBlessed, "Corridor must be blessed first");
        flows[flowId].dignityCertified = true;
        emit DignityCertified(senderName);
    }

    function isBlessedAndCertified(string memory senderName, string memory originCountry, string memory destinationCountry, uint256 amount) public view returns (bool) {
        bytes32 flowId = keccak256(abi.encodePacked(senderName, originCountry, destinationCountry, amount));
        return flows[flowId].corridorBlessed && flows[flowId].dignityCertified;
    }
}
