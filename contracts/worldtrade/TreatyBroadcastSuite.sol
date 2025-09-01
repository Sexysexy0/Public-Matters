// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract TreatyBroadcastSuite {
    struct Broadcast {
        string treatyName;
        string countryA;
        string countryB;
        uint256 emotionalAPR;
        string blessingClause;
        string prophecyTag;
        uint256 timestamp;
    }

    Broadcast[] public broadcasts;

    event TreatyBroadcasted(
        string treatyName,
        string countryA,
        string countryB,
        uint256 emotionalAPR,
        string blessingClause,
        string prophecyTag
    );

    function broadcastTreaty(
        string memory _treatyName,
        string memory _countryA,
        string memory _countryB,
        uint256 _emotionalAPR,
        string memory _blessingClause,
        string memory _prophecyTag
    ) public {
        broadcasts.push(Broadcast(
            _treatyName,
            _countryA,
            _countryB,
            _emotionalAPR,
            _blessingClause,
            _prophecyTag,
            block.timestamp
        ));

        emit TreatyBroadcasted(
            _treatyName,
            _countryA,
            _countryB,
            _emotionalAPR,
            _blessingClause,
            _prophecyTag
        );
    }

    function getAllBroadcasts() public view returns (Broadcast[] memory) {
        return broadcasts;
    }
}
