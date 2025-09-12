// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BilateralTradeSanctifier {
    enum Nation { UnitedStates, India, Philippines, Japan, EU, ASEAN }
    enum Sector { Food, Medicine, Agriculture, Technology, Energy }
    enum AgreementStatus { Proposed, Active, Suspended, Terminated }

    struct TradeAgreement {
        uint256 id;
        Nation partyA;
        Nation partyB;
        Sector sector;
        string sharedGoals;
        string resourceExchange;
        uint256 startDate;
        AgreementStatus status;
        string diplomaticClause;
    }

    mapping(uint256 => TradeAgreement) public agreementRegistry;
    uint256 public agreementCount;

    event AgreementProposed(uint256 id, Nation partyA, Nation partyB, Sector sector);
    event AgreementActivated(uint256 id);
    event AgreementSuspended(uint256 id);
    event AgreementTerminated(uint256 id);

    function proposeAgreement(
        Nation partyA,
        Nation partyB,
        Sector sector,
        string memory sharedGoals,
        string memory resourceExchange,
        uint256 startDate,
        string memory diplomaticClause
    ) public {
        agreementRegistry[agreementCount] = TradeAgreement(
            agreementCount,
            partyA,
            partyB,
            sector,
            sharedGoals,
            resourceExchange,
            startDate,
            AgreementStatus.Proposed,
            diplomaticClause
        );
        emit AgreementProposed(agreementCount, partyA, partyB, sector);
        agreementCount++;
    }

    function activateAgreement(uint256 id) public {
        require(id < agreementCount, "Invalid agreement ID");
        agreementRegistry[id].status = AgreementStatus.Active;
        emit AgreementActivated(id);
    }

    function suspendAgreement(uint256 id) public {
        require(id < agreementCount, "Invalid agreement ID");
        agreementRegistry[id].status = AgreementStatus.Suspended;
        emit AgreementSuspended(id);
    }

    function terminateAgreement(uint256 id) public {
        require(id < agreementCount, "Invalid agreement ID");
        agreementRegistry[id].status = AgreementStatus.Terminated;
        emit AgreementTerminated(id);
    }

    function getAgreement(uint256 id) public view returns (TradeAgreement memory) {
        return agreementRegistry[id];
    }
}
