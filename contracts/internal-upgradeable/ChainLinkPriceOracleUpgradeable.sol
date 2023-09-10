// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { IAggregatorV3 } from "../interfaces/IAggregatorV3.sol";
import { FixedPointMathLib } from "../libraries/FixedPointMathLib.sol";
import { BaseUpgradeable } from "./BaseUpgradeable.sol";
import { OPERATOR_ROLE } from "../libraries/Constants.sol";

abstract contract ChainLinkPriceOracleUpgradeable is BaseUpgradeable {
    using FixedPointMathLib for uint256;

    event SetPriceFeeds(address token, address priceFeed);
    event SetTokenPrice(address token, uint256 price);

    mapping(address => IAggregatorV3) internal _priceFeeds;
    mapping(address => uint256) internal _tokenPrices;
    mapping(address => uint256) internal _tokenDecimalAmount;

    function __ChainLinkPriceOracle_init() internal onlyInitializing {
        __ChainLinkPriceOracle_init_unchained();
    }

    function __ChainLinkPriceOracle_init_unchained() internal onlyInitializing {
        _setPriceFeeds(address(0), 0xd0D5e3DB44DE05E9F294BB0a3bEEaF030DE24Ada);
        _setTokenPrice(0x3AfB052aD80637a3e979a935Bd784e3E07D258d3, 1e18);
        _setTokenDecimalAmount(address(0), 1e18);
        _setTokenDecimalAmount(0x3AfB052aD80637a3e979a935Bd784e3E07D258d3, 1e6);
    }

    function getPrice(address token) external view returns (uint256) {
        return _getPrice(token);
    }

    function setPriceFeeds(address token_, address priceFeed_) external onlyRole(OPERATOR_ROLE) {
        _setPriceFeeds(token_, priceFeed_);
    }

    function setTokenPrice(address token_, uint256 tokenPrice_) external onlyRole(OPERATOR_ROLE) {
        _setTokenPrice(token_, tokenPrice_);
    }

    function setTokenDecimalAmount(address token_, uint256 tokenDecimalAmount_) external onlyRole(OPERATOR_ROLE) {
        _setTokenDecimalAmount(token_, tokenDecimalAmount_);
    }

    function _getPrice(address token) internal view returns (uint256) {
        IAggregatorV3 priceFeed = _priceFeeds[token];
        if (priceFeed != IAggregatorV3(address(0))) {
            (, int256 price, , , ) = priceFeed.latestRoundData();
            return uint256(price * 1e10);
        }
        return _tokenPrices[token];
    }

    function _getTokenAmountDown(address token, uint256 usdAmount) internal view returns (uint256) {
        uint256 price = _getPrice(token);
        return usdAmount.mulDivDown(_tokenDecimalAmount[token], price);
    }

    function _getTokenAmountUp(address token, uint256 usdAmount) internal view returns (uint256) {
        uint256 price = _getPrice(token);
        return usdAmount.mulDivUp(_tokenDecimalAmount[token], price);
    }

    function _setPriceFeeds(address token_, address priceFeed_) internal {
        _priceFeeds[token_] = IAggregatorV3(priceFeed_);
        emit SetPriceFeeds(token_, priceFeed_);
    }

    function _setTokenPrice(address token_, uint256 tokenPrice_) internal {
        _tokenPrices[token_] = tokenPrice_;
        emit SetTokenPrice(token_, tokenPrice_);
    }

    function _setTokenDecimalAmount(address token_, uint256 tokenDecimalAmount_) internal {
        _tokenDecimalAmount[token_] = tokenDecimalAmount_;
    }

    uint256[48] private __gap;
}
