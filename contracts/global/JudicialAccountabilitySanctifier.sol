// SPDX-License-Identifier: CivicSanctum
pragma solidity ^0.8.19;

contract JudicialAccountabilitySanctifier {
    struct Ruling {
        string caseName;
        string judgeName;
        bool rulingContested;
        bool sentToCongress;
        bool civicReviewPassed;
    }

    mapping(bytes32 => Ruling) public rulings;

    event RulingLogged(string caseName, string judgeName);
    event RulingContested(string caseName);
    event SentToCongress(string caseName);
    event CivicReviewPassed(string caseName);

    function logRuling(string memory caseName, string memory judgeName) public {
        bytes32 rulingId = keccak256(abi.encodePacked(caseName, judgeName));
        rulings[rulingId] = Ruling(caseName, judgeName, false, false, false);
        emit RulingLogged(caseName, judgeName);
    }

    function contestRuling(string memory caseName, string memory judgeName) public {
        bytes32 rulingId = keccak256(abi.encodePacked(caseName, judgeName));
        rulings[rulingId].rulingContested = true;
        emit RulingContested(caseName);
    }

    function sendToCongress(string memory caseName, string memory judgeName) public {
        bytes32 rulingId = keccak256(abi.encodePacked(caseName, judgeName));
        require(rulings[rulingId].rulingContested, "Ruling must be contested first");
        rulings[rulingId].sentToCongress = true;
        emit SentToCongress(caseName);
    }

    function passCivicReview(string memory caseName, string memory judgeName) public {
        bytes32 rulingId = keccak256(abi.encodePacked(caseName, judgeName));
        require(rulings[rulingId].sentToCongress, "Must be sent to Congress first");
        rulings[rulingId].civicReviewPassed = true;
        emit CivicReviewPassed(caseName);
    }

    function isReviewPassed(string memory caseName, string memory judgeName) public view returns (bool) {
        bytes32 rulingId = keccak256(abi.encodePacked(caseName, judgeName));
        return rulings[rulingId].civicReviewPassed;
    }
}
