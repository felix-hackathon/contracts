// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import { UUPSUpgradeable } from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import { AccessControlEnumerableUpgradeable } from "./internal-upgradeable/AccessControlEnumerableUpgradeable.sol";
import { EIP712Upgradeable, ECDSAUpgradeable } from "./internal-upgradeable/EIP712Upgradeable.sol";
import { IRoleManagerUpgradeable } from "./interfaces/IRoleManagerUpgradeable.sol";
import { MINTER_ROLE, OPERATOR_ROLE, UPGRADER_ROLE } from "./libraries/Constants.sol";
import { EIP712Upgradeable, ECDSAUpgradeable } from "./internal-upgradeable/EIP712Upgradeable.sol";

contract RoleManagerUpgradeable is
    Initializable,
    UUPSUpgradeable,
    IRoleManagerUpgradeable,
    AccessControlEnumerableUpgradeable,
    EIP712Upgradeable
{
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(
        address admin_,
        address[] calldata operators_,
        address[] calldata minters,
        string calldata name_,
        string calldata version_
    ) external initializer {
        __AccessControl_init();
        __UUPSUpgradeable_init();
        __EIP712_init_unchained(name_, version_);
        _grantRoles(OPERATOR_ROLE, operators_);
        _grantRoles(MINTER_ROLE, minters);
        _grantRole(UPGRADER_ROLE, admin_);
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
