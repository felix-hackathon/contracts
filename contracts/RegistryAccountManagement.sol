// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { BaseUpgradeable } from "./internal-upgradeable/BaseUpgradeable.sol";
import { AccountRegistryUpgradeable } from "./internal-upgradeable/AccountRegistryUpgradeable.sol";
import { IERC6551Registry } from "./interfaces/IERC6551Registry.sol";

contract RegistryAccountManagement is BaseUpgradeable, AccountRegistryUpgradeable {
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(
        address roleManager_,
        IERC6551Registry registry_,
        address implementation_
    ) external initializer {
        __BaseUpgradeable_init_unchained(roleManager_);
        __AccountRegistryUpgradeable_init_unchained(registry_, implementation_);
    }

    function batchCreatAccount(address tokenCollection_, uint256[] calldata tokenIds_) external {
        uint256 length = tokenIds_.length;
        uint256 chainId = block.chainid;
        IERC6551Registry registry = _registry;
        address implementation = _implementation;
        address tba;

        for (uint256 i = 0; i < length; ) {
            tba = registry.createAccount(implementation, chainId, tokenCollection_, i, 0, "");

            unchecked {
                ++i;
            }
        }
    }

    function batchCreatAccount(address tokenCollection_, uint256 from_, uint256 to_) external {
        uint256 chainId = block.chainid;
        IERC6551Registry registry = _registry;
        address implementation = _implementation;
        address tba;

        for (uint256 i = from_; i <= to_; ) {
            tba = registry.createAccount(implementation, chainId, tokenCollection_, i, 0, "");

            unchecked {
                ++i;
            }
        }
    }
}
