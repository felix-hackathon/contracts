// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { IBaseUpgradeable } from "./IBaseUpgradeable.sol";

interface IBaseCollectionUpgradeable is IBaseUpgradeable {
    error InsufficientBalance();
    error NFT__InvalidType();

    struct CollectionPart {
        address collection;
        uint256 typePart;
    }

    function buy(uint256 type_, CollectionPart[] calldata collectionParts_, address recipient_) external payable;

    event BaseCollectionMinted(address indexed recipient, uint256 indexed typeNFT, uint256 tokenId);
}
