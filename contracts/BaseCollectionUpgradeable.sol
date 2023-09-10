// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {
    ERC721Upgradeable,
    ERC721EnumerableUpgradeable
} from "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import { ERC721URIStorageUpgradeable } from "./internal-upgradeable/ERC721URIStorageUpgradeable.sol";
import { ERC721BurnableUpgradeable } from "./internal-upgradeable/ERC721BurnableUpgradeable.sol";
import { EIP712Upgradeable, ERC721WithPermitUpgradable } from "./internal-upgradeable/ERC721WithPermitUpgradable.sol";
import { IRoleManagerUpgradeable, BaseUpgradeable } from "./internal-upgradeable/BaseUpgradeable.sol";
import {
    ICollectionTypeUpgradeable,
    CollectionTypeUpgradeable
} from "./internal-upgradeable/CollectionTypeUpgradeable.sol";
import { AccountRegistryUpgradeable } from "./internal-upgradeable/AccountRegistryUpgradeable.sol";
import { ReentrancyGuardUpgradeable } from "./internal-upgradeable/ReentrancyGuardUpgradeable.sol";
import { Helper } from "./libraries/Helper.sol";
import { MINTER_ROLE } from "./libraries/Constants.sol";
import { SafeTransferLib } from "./libraries/SafeTransfer.sol";

import { IERC721Upgradeable } from "./interfaces/IERC721Upgradeable.sol";
import { IERC6551Registry } from "./interfaces/IERC6551Registry.sol";
import { IBaseCollectionUpgradeable } from "./interfaces/IBaseCollectionUpgradeable.sol";

contract BaseCollectionUpgradeable is
    IBaseCollectionUpgradeable,
    BaseUpgradeable,
    CollectionTypeUpgradeable,
    AccountRegistryUpgradeable,
    ReentrancyGuardUpgradeable,
    ERC721BurnableUpgradeable,
    ERC721EnumerableUpgradeable,
    ERC721URIStorageUpgradeable,
    ERC721WithPermitUpgradable
{
    using Helper for *;

    uint256 private _idCounter;
    mapping(uint256 => uint256) private _types;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(
        address roleManager_,
        string calldata name_,
        string calldata symbol_,
        IERC6551Registry registry_,
        address implementation_,
        string calldata uri_,
        TypeInfo[] calldata typeInfos_
    ) external initializer {
        __ReentrancyGuard_init_unchained();
        __BaseUpgradeable_init_unchained(roleManager_);
        __ERC721WithPermitUpgradable_init(name_, symbol_);
        __ERC721URIStorage_init_unchained(uri_);
        __AccountRegistryUpgradeable_init_unchained(registry_, implementation_);
        __CollectionType_init_unchained(typeInfos_);
    }

    function getTokenType(uint256 tokenId) external view returns (uint256) {
        return _types[tokenId];
    }

    function buy(
        uint256 type_,
        CollectionPart[] calldata accessories_,
        address recipient_
    ) external payable nonReentrant {
        TypeInfo memory typeInfo = _typeInfo[type_];
        uint256 totalPrice = typeInfo.price;

        uint256 tokenId = ++_idCounter;
        _safeMint(recipient_, tokenId);
        _types[tokenId] = type_;

        uint256 length = accessories_.length;
        address tba = _registry.createAccount(_implementation, block.chainid, address(this), tokenId, 0, "");

        for (uint256 i = 0; i < length; ) {
            (, uint256 price) = ICollectionTypeUpgradeable(accessories_[i].collection).getTypeNFT(
                accessories_[i].typePart
            );

            totalPrice += price;

            IERC721Upgradeable(accessories_[i].collection).safeMint(accessories_[i].typePart, tba);
            unchecked {
                ++i;
            }
        }

        uint256 value = msg.value;

        if (value < totalPrice) revert InsufficientBalance();
        SafeTransferLib.safeTransferETH(IRoleManagerUpgradeable(roleManager).admin(), value);

        emit BaseCollectionMinted(recipient_, type_, tokenId);
    }

    // The following functions are overrides required by Solidity.

    function _baseURI() internal view override(ERC721URIStorageUpgradeable, ERC721Upgradeable) returns (string memory) {
        return _baseUri;
    }

    function exists(uint256 tokenId) external view returns (bool) {
        return _exists(tokenId);
    }

    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721Upgradeable, ERC721URIStorageUpgradeable) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function _beforeTokenTransfer(
        address from_,
        address to_,
        uint256 tokenId_,
        uint256 batchSize_
    ) internal override(ERC721Upgradeable, ERC721EnumerableUpgradeable) {
        super._beforeTokenTransfer(from_, to_, tokenId_, batchSize_);
    }

    function _transfer(
        address from_,
        address to_,
        uint256 tokenId_
    ) internal override(ERC721Upgradeable, ERC721WithPermitUpgradable) {
        super._transfer(from_, to_, tokenId_);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721Upgradeable, ERC721EnumerableUpgradeable, ERC721WithPermitUpgradable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
