// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TieredApproval
 * @notice Authority-tier classification for governance actions.
 *
 * Thresholds are expressed as rational fractions (numerator/denominator)
 * with a `strict` flag:
 *   strict = true  -> "more than"  (floor(total*n/d) + 1)
 *   strict = false -> "at least"   (ceil(total*n/d))
 *
 * Tiers:
 *   OPERATOR      - any registered operator (no threshold)
 *   MAJORITY      - strictly more than 50% of board AND stockholders
 *   SUPERMAJORITY - at least 2/3 of board AND stockholders
 *   UNANIMOUS     - 100% of board AND stockholders
 *
 * Design note: this contract does NOT block a single actor from
 * executing at the supermajority tier. It records it in `soleActor`.
 * That is deliberate — the record should say what happened, not
 * pretend a coalition existed.
 */
abstract contract TieredApproval {
    enum Tier { NONE, OPERATOR, MAJORITY, SUPERMAJORITY, UNANIMOUS }

    struct Threshold {
        uint16 numerator;
        uint16 denominator;
        bool   strict;      // true => "more than"; false => "at least"
    }

    struct Action {
        Tier     required;
        uint256  boardFor;
        uint256  stockholderFor;
        address  soleActor;
        bool     resolved;
        uint256  resolvedAt;
    }

    mapping(Tier => Threshold) public boardRule;
    mapping(Tier => Threshold) public stockholderRule;

    uint256 public boardTotal;
    uint256 public stockholderTotal;

    mapping(bytes32 => Action) internal _actions;

    event CompositionUpdated(uint256 boardTotal, uint256 stockholderTotal);
    event ActionResolved(
        bytes32 indexed actionId,
        Tier            tier,
        uint256         boardFor,
        uint256         stockholderFor,
        address indexed soleActor
    );

    constructor() {
        // OPERATOR: no threshold
        boardRule[Tier.OPERATOR]       = Threshold(0, 1, false);
        stockholderRule[Tier.OPERATOR] = Threshold(0, 1, false);

        // MAJORITY: strictly more than 1/2
        boardRule[Tier.MAJORITY]       = Threshold(1, 2, true);
        stockholderRule[Tier.MAJORITY] = Threshold(1, 2, true);

        // SUPERMAJORITY: at least 2/3
        boardRule[Tier.SUPERMAJORITY]       = Threshold(2, 3, false);
        stockholderRule[Tier.SUPERMAJORITY] = Threshold(2, 3, false);

        // UNANIMOUS: 100%
        boardRule[Tier.UNANIMOUS]       = Threshold(1, 1, false);
        stockholderRule[Tier.UNANIMOUS] = Threshold(1, 1, false);
    }

    function _setComposition(uint256 _boardTotal, uint256 _stockholderTotal) internal {
        boardTotal = _boardTotal;
        stockholderTotal = _stockholderTotal;
        emit CompositionUpdated(_boardTotal, _stockholderTotal);
    }

    /// @notice Minimum board votes required for `tier`.
    function requiredBoard(Tier tier) public view returns (uint256) {
        if (tier == Tier.NONE || tier == Tier.OPERATOR) return 0;
        return _required(boardTotal, boardRule[tier]);
    }

    /// @notice Minimum stockholder weight (in same units as `stockholderTotal`).
    function requiredStockholder(Tier tier) public view returns (uint256) {
        if (tier == Tier.NONE || tier == Tier.OPERATOR) return 0;
        return _required(stockholderTotal, stockholderRule[tier]);
    }

    function meetsThreshold(
        Tier    tier,
        uint256 boardFor,
        uint256 stockholderFor
    ) public view returns (bool) {
        if (tier == Tier.NONE) return false;
        if (tier == Tier.OPERATOR) return true;
        return boardFor >= requiredBoard(tier)
            && stockholderFor >= requiredStockholder(tier);
    }

    function _required(uint256 total, Threshold memory t) internal pure returns (uint256) {
        if (t.denominator == 0) return 0;
        uint256 base = total * t.numerator;
        if (t.strict) {
            return base / t.denominator + 1;
        }
        return (base + t.denominator - 1) / t.denominator;  // ceiling
    }

    function _resolveAction(
        bytes32 actionId,
        Tier    tier,
        uint256 boardFor,
        uint256 stockholderFor,
        address actor,
        uint256 actorBoardWeight,
        uint256 actorStockholderWeight
    ) internal {
        require(!_actions[actionId].resolved, "Already resolved");
        require(meetsThreshold(tier, boardFor, stockholderFor), "Tier not achieved");

        address sole = address(0);
        if (tier != Tier.OPERATOR && tier != Tier.NONE) {
            bool actorCarriedBoard = actorBoardWeight >= requiredBoard(tier);
            bool actorCarriedStock = actorStockholderWeight >= requiredStockholder(tier);
            if (actorCarriedBoard && actorCarriedStock) {
                sole = actor;
            }
        }

        _actions[actionId] = Action({
            required:        tier,
            boardFor:        boardFor,
            stockholderFor:  stockholderFor,
            soleActor:       sole,
            resolved:        true,
            resolvedAt:      block.timestamp
        });

        emit ActionResolved(actionId, tier, boardFor, stockholderFor, sole);
    }

    function getAction(bytes32 actionId) external view returns (Action memory) {
        return _actions[actionId];
    }
}
