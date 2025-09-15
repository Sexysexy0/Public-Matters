// SPDX-License-Identifier: PeaceSanctum
pragma solidity ^0.8.19;

contract PeaceManifestoRouter {
    struct Manifesto {
        string stewardName;
        string country;
        string message;
        bool unityPledged;
        bool broadcasted;
    }

    mapping(bytes32 => Manifesto) public manifestos;

    event ManifestoRegistered(string stewardName, string country);
    event UnityPledged(string stewardName);
    event ManifestoBroadcasted(string stewardName, string message);

    function registerManifesto(string memory stewardName, string memory country, string memory message) public {
        bytes32 manifestoId = keccak256(abi.encodePacked(stewardName, country, block.timestamp));
        manifestos[manifestoId] = Manifesto(stewardName, country, message, false, false);
        emit ManifestoRegistered(stewardName, country);
    }

    function pledgeUnity(string memory stewardName, string memory country) public {
        bytes32 manifestoId = keccak256(abi.encodePacked(stewardName, country, block.timestamp));
        manifestos[manifestoId].unityPledged = true;
        emit UnityPledged(stewardName);
    }

    function broadcastManifesto(string memory stewardName, string memory country, string memory message) public {
        bytes32 manifestoId = keccak256(abi.encodePacked(stewardName, country, block.timestamp));
        manifestos[manifestoId].broadcasted = true;
        manifestos[manifestoId].message = message;
        emit ManifestoBroadcasted(stewardName, message);
    }

    function getManifestoStatus(string memory stewardName, string memory country) public view returns (Manifesto memory) {
        bytes32 manifestoId = keccak256(abi.encodePacked(stewardName, country, block.timestamp));
        return manifestos[manifestoId];
    }
}
