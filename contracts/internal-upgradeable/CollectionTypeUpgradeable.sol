// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import { ICollectionTypeUpgradeable } from "../interfaces/ICollectionTypeUpgradeable.sol";
import { BaseUpgradeable } from "./BaseUpgradeable.sol";
import { OPERATOR_ROLE } from "../libraries/Constants.sol";

abstract contract CollectionTypeUpgradeable is ICollectionTypeUpgradeable, BaseUpgradeable {
    mapping(uint256 => TypeInfo) internal _typeInfo;

    function __CollectionType_init(TypeInfo[] calldata typeInfos_) internal onlyInitializing {
        __CollectionType_init_unchained(typeInfos_);
    }

    function __CollectionType_init_unchained(TypeInfo[] calldata typeInfos_) internal onlyInitializing {
        uint256 length = typeInfos_.length;
        for (uint256 i = 0; i < length; ) {
            _setType(i + 1, typeInfos_[i]);
            unchecked {
                ++i;
            }
        }
    }

    function getTypeNFT(uint256 typeNFT) external view returns (address, uint256) {
        return (_typeInfo[typeNFT].paymentToken, _typeInfo[typeNFT].price);
    }

    function setTypes(uint256[] calldata types_, TypeInfo[] calldata typeInfos_) external onlyRole(OPERATOR_ROLE) {
        _setTypes(types_, typeInfos_);
    }

    function _setTypes(uint256[] calldata types_, TypeInfo[] calldata typeInfos_) internal {
        uint256 length = types_.length;
        for (uint256 i = 0; i < length; ) {
            _setType(types_[i], typeInfos_[i]);
            unchecked {
                ++i;
            }
        }
    }

    function _setType(uint256 type_, TypeInfo calldata typeInfo_) internal {
        _typeInfo[type_] = typeInfo_;
        emit SetTypeNFT(type_, typeInfo_);
    }

    uint256[49] private __gap;
}
