// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

// external
import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import { UUPSUpgradeable } from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import { ContextUpgradeable } from "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";

import { IAccessControlUpgradeable } from "../interfaces/IAccessControlUpgradeable.sol";
import { IBaseUpgradeable } from "../interfaces/IBaseUpgradeable.sol";
import { IRoleManagerUpgradeable } from "../interfaces/IRoleManagerUpgradeable.sol";
import { UPGRADER_ROLE } from "../libraries/Constants.sol";

contract BaseUpgradeable is IBaseUpgradeable, Initializable, UUPSUpgradeable, ContextUpgradeable {
    address public override roleManager;

    modifier onlyRole(bytes32 role) {
        if (!_checkRole(role)) revert BaseUpgradeable__NotAuthorized();
        _;
    }

    function __BaseUpgradeable_init(address roleManager_) internal onlyInitializing {
        __BaseUpgradeable_init_unchained(roleManager_);
    }

    function __BaseUpgradeable_init_unchained(address roleManager_) internal onlyInitializing {
        roleManager = roleManager_;
    }

    function setRoleManager(address roleManager_) external override onlyRole(UPGRADER_ROLE) {
        roleManager = roleManager_;
    }

    function _call(Operation memory operation_) internal returns (bytes memory result) {
        bool success;
        (success, result) = operation_.to.call{ value: operation_.value }(operation_.data);

        if (!success) {
            assembly {
                revert(add(result, 32), mload(result))
            }
        }
    }

    /* solhint-disable no-empty-blocks */
    function _authorizeUpgrade(address newImplementation) internal virtual override onlyRole(UPGRADER_ROLE) {}

    function _checkRole(bytes32 role) internal view returns (bool) {
        if (IAccessControlUpgradeable(roleManager).hasRole(role, _msgSender())) return true;

        return false;
    }

    uint256[49] private __gap;
}
