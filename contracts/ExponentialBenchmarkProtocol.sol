pragma solidity ^0.8.20;

contract ExponentialBenchmarkProtocol {
    address public admin;

    struct Benchmark {
        string test;         // e.g. GPQA, SWE Bench, AIME
        uint256 score;       // e.g. 94, 81, 100
        string implication;  // e.g. exponential improvement, surpassing human experts
        uint256 timestamp;
    }

    Benchmark[] public benchmarks;

    event BenchmarkLogged(string test, uint256 score, string implication, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logBenchmark(string calldata test, uint256 score, string calldata implication) external onlyAdmin {
        benchmarks.push(Benchmark(test, score, implication, block.timestamp));
        emit BenchmarkLogged(test, score, implication, block.timestamp);
    }

    function totalBenchmarks() external view returns (uint256) {
        return benchmarks.length;
    }
}
