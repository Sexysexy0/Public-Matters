// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract GoldRepatriationProtocol {
    struct Reserve {
        string originCountry;
        string assetID;
        uint256 weightInKg;
        string status; // "Offshore", "InTransit", "Repatriated"
        string ancestralTag;
        string timestamp;
    }

    mapping(string => Reserve) public reserves;
    string[] public reserveIDs;

    event ReserveLogged(string assetID, string originCountry);
    event RepatriationInitiated(string assetID);
    event RepatriationCompleted(string assetID);

    function logOffshoreReserve(
        string memory _originCountry,
        string memory _assetID,
        uint256 _weightInKg,
        string memory _ancestralTag,
        string memory _timestamp
    ) public {
        Reserve memory newReserve = Reserve({
            originCountry: _originCountry,
            assetID: _assetID,
            weightInKg: _weightInKg,
            status: "Offshore",
            ancestralTag: _ancestralTag,
            timestamp: _timestamp
        });

        reserves[_assetID] = newReserve;
        reserveIDs.push(_assetID);
        emit ReserveLogged(_assetID, _originCountry);
    }

    function initiateRepatriation(string memory _assetID) public {
        Reserve storage reserve = reserves[_assetID];
        require(keccak256(bytes(reserve.status)) == keccak256("Offshore"), "Already in transit or repatriated");
        reserve.status = "InTransit";
        emit RepatriationInitiated(_assetID);
    }

    function completeRepatriation(string memory _assetID, string memory _timestamp) public {
        Reserve storage reserve = reserves[_assetID];
        require(keccak256(bytes(reserve.status)) == keccak256("InTransit"), "Repatriation not initiated");
        reserve.status = "Repatriated";
        reserve.timestamp = _timestamp;
        emit RepatriationCompleted(_assetID);
    }

    function getReserveCount() public view returns (uint256) {
        return reserveIDs.length;
    }
}
