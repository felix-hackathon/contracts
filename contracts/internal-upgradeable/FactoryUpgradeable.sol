// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import { IProxy } from "../interfaces/IProxy.sol";
import { BaseUpgradeable } from "./BaseUpgradeable.sol";
import { ErrorHandler } from "../libraries/ErrorHandler.sol";
import { ClonesUpgradeable } from "../libraries/ClonesUpgradeable.sol";
import { EnumerableSetUpgradeable } from "../libraries/EnumerableSetUpgradeable.sol";
import { UPGRADER_ROLE } from "../libraries/Constants.sol";

abstract contract FactoryUpgradeable is BaseUpgradeable {
    using ErrorHandler for bool;
    using ClonesUpgradeable for address;
    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.AddressSet;

    event NewInstance(bytes32 salt, address indexed clone);

    address public implementation;
    EnumerableSetUpgradeable.AddressSet internal _instances;

    function __Factory_init(address implement_) internal onlyInitializing {
        __Factory_init_unchained(implement_);
    }

    function __Factory_init_unchained(address implement_) internal onlyInitializing {
        _setImplement(implement_);
    }

    function setImplement(address implement_) external onlyRole(UPGRADER_ROLE) {
        _setImplement(implement_);
        // _batchUpgradeTo(implement_);
    }

    function _setImplement(address implement_) internal {
        implementation = implement_;
    }

    function _batchUpgradeTo(address implement_) internal {
        uint256 length = _instances.length();
        // Notice: exceed block gas limit
        for (uint256 i = 0; i < length; ) {
            IProxy(_instances.at(i)).upgradeTo(implement_);
            unchecked {
                ++i;
            }
        }
    }

    function _cheapClone(bytes32 salt_, bytes4 selector_, bytes memory args_) internal returns (address clone) {
        clone = implementation.cloneDeterministic(salt_);
        emit NewInstance(salt_, clone);

        (bool success, bytes memory revertData) = clone.call(abi.encodePacked(selector_, args_));

        if (!success) success.handleRevertIfNotSuccess(revertData);

        _instances.add(clone);
    }

    function viewInstanceAddresses(uint256 cursor, uint256 size) external view returns (address[] memory instances) {
        // skip the overflow check
        instances = new address[](size);
        for (uint i = 0; i < size; ) {
            instances[i] = _instances.at(cursor + i);
            unchecked {
                ++i;
            }
        }
    }

    uint256[48] private __gap;
}
