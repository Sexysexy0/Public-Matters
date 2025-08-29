// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title HousingGuaranteeActV4
 * @notice Anti-vacancy levy on idle developer units; proceeds flow to housing fund.
 */
contract HousingGuaranteeActV4 {
    address public steward;
    uint16 public constant BPS = 10_000;

    enum UnitStatus { Available, Reserved, Occupied }

    struct Unit {
        uint256 id;
        string  location;
        address developer;
        uint256 monthlyRent;
        UnitStatus status;
        uint256 addedAt;
        uint256 lastLevyAt;
    }

    mapping(address => bool) public developers;
    mapping(uint256 => Unit) public units;
    uint256 public unitCount;

    // Levy policy
    uint256 public vacancyThresholdDays = 60 days; // idle for > threshold triggers levy
    uint16  public levyBps = 500;                  // 5% of monthlyRent per levy period
    address public housingFund;                    // destination of levies

    // Accounting
    mapping(address => uint256) public levyDueByDeveloper;

    event DeveloperSet(address dev, bool status);
    event HousingFundSet(address fund);
    event UnitListed(uint256 unitId, address developer, string location, uint256 monthlyRent);
    event VacancyAccrued(uint256 unitId, address developer, uint256 levyAmount);
    event LevyPaid(address developer, uint256 amount);

    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }

    constructor(address _housingFund) {
        steward = msg.sender;
        housingFund = _housingFund;
        developers[msg.sender] = true;
    }

    function setDeveloper(address d, bool s) external onlySteward { developers[d]=s; emit DeveloperSet(d,s); }
    function setPolicy(uint256 threshold, uint16 bps) external onlySteward {
        vacancyThresholdDays = threshold;
        require(bps <= BPS, "bps>100%");
        levyBps = bps;
    }
    function setHousingFund(address fund) external onlySteward { housingFund = fund; emit HousingFundSet(fund); }

    function listUnit(string calldata location, uint256 monthlyRent) external {
        require(developers[msg.sender], "Not developer");
        unitCount++;
        units[unitCount] = Unit({
            id: unitCount,
            location: location,
            developer: msg.sender,
            monthlyRent: monthlyRent,
            status: UnitStatus.Available,
            addedAt: block.timestamp,
            lastLevyAt: block.timestamp
        });
        emit UnitListed(unitCount, msg.sender, location, monthlyRent);
    }

    // Steward or any caller can accrue levy on idle available units
    function accrueVacancyLevy(uint256 unitId) external {
        Unit storage u = units[unitId];
        require(u.status == UnitStatus.Available, "Not idle");
        uint256 idleTime = block.timestamp - u.lastLevyAt;
        if (block.timestamp < u.addedAt + vacancyThresholdDays) {
            return; // not past threshold yet
        }
        // Charge once per threshold window elapsed since last levy
        uint256 periods = idleTime / vacancyThresholdDays;
        if (periods == 0) return;

        uint256 levyPerPeriod = (u.monthlyRent * levyBps) / BPS;
        uint256 totalLevy = levyPerPeriod * periods;

        levyDueByDeveloper[u.developer] += totalLevy;
        u.lastLevyAt += periods * vacancyThresholdDays;

        emit VacancyAccrued(unitId, u.developer, totalLevy);
    }

    function payLevy() external payable {
        uint256 due = levyDueByDeveloper[msg.sender];
        require(due > 0, "No levy due");
        require(msg.value == due, "Incorrect amount");
        levyDueByDeveloper[msg.sender] = 0;

        (bool ok, ) = payable(housingFund).call{value: msg.value}("");
        require(ok, "Fund transfer failed");

        emit LevyPaid(msg.sender, msg.value);
    }

    // For completeness: developers update status when unit gets reserved/occupied
    function markReserved(uint256 unitId) external {
        Unit storage u = units[unitId];
        require(msg.sender == u.developer, "Not developer");
        require(u.status == UnitStatus.Available, "Wrong status");
        u.status = UnitStatus.Reserved;
    }
    function markOccupied(uint256 unitId) external {
        Unit storage u = units[unitId];
        require(msg.sender == u.developer, "Not developer");
        require(u.status == UnitStatus.Reserved, "Wrong status");
        u.status = UnitStatus.Occupied;
    }

    receive() external payable {}
}
