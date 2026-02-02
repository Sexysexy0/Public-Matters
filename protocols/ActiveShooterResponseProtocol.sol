// ActiveShooterResponseProtocol.sol
pragma solidity ^0.8.0;

contract ActiveShooterResponseProtocol {
    struct Drill {
        uint256 id;
        string location;   // e.g. "Corporate Campus", "School"
        address coordinator;
        uint256 timestamp;
    }

    uint256 public drillCount;
    mapping(uint256 => Drill) public drills;

    event DrillLogged(uint256 id, string location, address coordinator, uint256 timestamp);
    event ShooterDeclared(string message);

    function logDrill(string memory location) public {
        drillCount++;
        drills[drillCount] = Drill(drillCount, location, msg.sender, block.timestamp);
        emit DrillLogged(drillCount, location, msg.sender, block.timestamp);
    }

    function declareShooter() public {
        emit ShooterDeclared("Active Shooter Response Protocol: communal drills encoded into resilience seals.");
    }
}
