// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import { IBaseUpgradeable } from "./IBaseUpgradeable.sol";

interface ICollectionTypeUpgradeable {
    event SetTypeNFT(uint256 typeNFT, TypeInfo typeInfo);

    struct TypeInfo {
        address paymentToken;
        uint256 price;
    }

    function getTypeNFT(uint256 typeNFT) external view returns (address, uint256);
}
