// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract GlobalTradeRerouteProtocol {
    struct ImportBundle {
        string originCountry;
        string contents;
        uint256 baseFee;
        bool claimed;
        string claimingCountry;
        uint256 timestamp;
        address steward;
    }

    ImportBundle[] public bundles;

    event BundleSubmitted(
        string originCountry,
        string contents,
        uint256 baseFee,
        uint256 timestamp,
        address steward
    );

    event BundleClaimed(
        uint256 index,
        string claimingCountry,
        uint256 timestamp,
        address steward
    );

    function submitBundle(
        string memory _originCountry,
        string memory _contents,
        uint256 _baseFee
    ) public {
        bundles.push(ImportBundle({
            originCountry: _originCountry,
            contents: _contents,
            baseFee: _baseFee,
            claimed: false,
            claimingCountry: "",
            timestamp: block.timestamp,
            steward: msg.sender
        }));

        emit BundleSubmitted(_originCountry, _contents, _baseFee, block.timestamp, msg.sender);
    }

    function claimBundle(uint256 index, string memory _claimingCountry) public {
        require(index < bundles.length, "Invalid index");
        require(!bundles[index].claimed, "Bundle already claimed");

        bundles[index].claimed = true;
        bundles[index].claimingCountry = _claimingCountry;

        emit BundleClaimed(index, _claimingCountry, block.timestamp, msg.sender);
    }

    function getBundle(uint256 index) public view returns (ImportBundle memory) {
        require(index < bundles.length, "Invalid index");
        return bundles[index];
    }

    function totalBundles() public view returns (uint256) {
        return bundles.length;
    }
}
