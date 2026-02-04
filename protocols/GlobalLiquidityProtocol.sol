// GlobalLiquidityProtocol.sol
pragma solidity ^0.8.0;

contract GlobalLiquidityProtocol {
    struct Flow {
        uint256 id;
        string source;   // e.g. "Cross-border Capital", "Stablecoin Expansion"
        uint256 volume;
        uint256 timestamp;
    }

    uint256 public flowCount;
    mapping(uint256 => Flow) public flows;

    event FlowLogged(uint256 id, string source, uint256 volume, uint256 timestamp);
    event LiquidityDeclared(string message);

    function logFlow(string memory source, uint256 volume) public {
        flowCount++;
        flows[flowCount] = Flow(flowCount, source, volume, block.timestamp);
        emit FlowLogged(flowCount, source, volume, block.timestamp);
    }

    function declareLiquidity() public {
        emit LiquidityDeclared("Global Liquidity Protocol: capital arcs encoded into communal trust.");
    }
}
