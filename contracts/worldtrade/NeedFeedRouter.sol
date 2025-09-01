// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract NeedFeedRouter {
    struct TradeRoute {
        string exporter;
        string exportItem;
        uint256 quantity;
        string importer;
        string importNeed;
        string timestamp;
        string blessingTag;
    }

    TradeRoute[] public routes;

    event RouteMapped(string exporter, string importer, string exportItem);

    function mapRoute(
        string memory _exporter,
        string memory _exportItem,
        uint256 _quantity,
        string memory _importer,
        string memory _importNeed,
        string memory _timestamp,
        string memory _blessingTag
    ) public {
        routes.push(TradeRoute({
            exporter: _exporter,
            exportItem: _exportItem,
            quantity: _quantity,
            importer: _importer,
            importNeed: _importNeed,
            timestamp: _timestamp,
            blessingTag: _blessingTag
        }));

        emit RouteMapped(_exporter, _importer, _exportItem);
    }

    function getRouteCount() public view returns (uint256) {
        return routes.length;
    }
}
