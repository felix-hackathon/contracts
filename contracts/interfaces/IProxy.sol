// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

interface IProxy {
    function upgradeTo(address newImplementation) external;

    function upgradeToAndCall(address newImplementation, bytes memory data) external;
}
