// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import { UUPSUpgradeable } from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import { AccessControlEnumerableUpgradeable } from "./AccessControlEnumerableUpgradeable.sol";
import { IRoleManagerUpgradeable } from "../interfaces/IRoleManagerUpgradeable.sol";
import { MINTER_ROLE, OPERATOR_ROLE, SIGNER_ROLE, UPGRADER_ROLE } from "../libraries/Constants.sol";

contract RolesUpgradeable is
    Initializable,
    UUPSUpgradeable,
    IRoleManagerUpgradeable,
    AccessControlEnumerableUpgradeable
{
    function __RolesUpgradeable_init(
        address admin_,
        address signer_,
        address[] calldata operators_
    ) internal onlyInitializing {
        __RolesUpgradeable_init_unchained(admin_, signer_, operators_);
    }

    function __RolesUpgradeable_init_unchained(
        address admin_,
        address signer_,
        address[] calldata operators_
    ) internal onlyInitializing {
        __AccessControl_init();
        __UUPSUpgradeable_init();
        _grantRole(SIGNER_ROLE, signer_);
        _grantRoles(OPERATOR_ROLE, operators_);
        _grantRole(DEFAULT_ADMIN_ROLE, admin_);
    }

    function admin() public view override returns (address) {
        return getRoleMember(DEFAULT_ADMIN_ROLE, 0);
    }

    function changeAdmin(address newAdmin_) external override onlyRole(DEFAULT_ADMIN_ROLE) {
        _revokeRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _grantRole(DEFAULT_ADMIN_ROLE, newAdmin_);
    }

    /* solhint-disable no-empty-blocks */
    function _authorizeUpgrade(address newImplementation) internal override onlyRole(UPGRADER_ROLE) {}
}
