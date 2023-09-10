// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {
    ERC721Upgradeable,
    ERC721EnumerableUpgradeable
} from "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";

import { BaseUpgradeable } from "./internal-upgradeable/BaseUpgradeable.sol";
import { CollectionTypeUpgradeable } from "./internal-upgradeable/CollectionTypeUpgradeable.sol";
import { ERC721URIStorageUpgradeable } from "./internal-upgradeable/ERC721URIStorageUpgradeable.sol";
import { ERC721BurnableUpgradeable } from "./internal-upgradeable/ERC721BurnableUpgradeable.sol";
import { EIP712Upgradeable, ERC721WithPermitUpgradable } from "./internal-upgradeable/ERC721WithPermitUpgradable.sol";

import { MINTER_ROLE } from "./libraries/Constants.sol";

contract AccessoryCollectionUpgradeable is
    BaseUpgradeable,
    CollectionTypeUpgradeable,
    ERC721WithPermitUpgradable,
    ERC721BurnableUpgradeable,
    ERC721EnumerableUpgradeable,
    ERC721URIStorageUpgradeable
{
    uint256 private _idCounter;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    event AccessoryMinted(address indexed recipient, uint256 indexed typeNFT, uint256 tokenId);

    function initialize(
        address roleManager_,
        string calldata name_,
        string calldata symbol_,
        string calldata uri_,
        TypeInfo[] calldata typeInfos_
    ) external initializer {
        __BaseUpgradeable_init_unchained(roleManager_);
        __ERC721WithPermitUpgradable_init(name_, symbol_);
        __ERC721URIStorage_init_unchained(uri_);
        __CollectionType_init_unchained(typeInfos_);
    }

    function safeMint(uint256 typeNFT_, address recipient_) external onlyRole(MINTER_ROLE) {
        uint256 tokenId = ++_idCounter;
        _safeMint(recipient_, tokenId);
        emit AccessoryMinted(recipient_, typeNFT_, tokenId);
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal override(ERC721Upgradeable, ERC721EnumerableUpgradeable) {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function _transfer(
        address from_,
        address to_,
        uint256 tokenId_
    ) internal override(ERC721Upgradeable, ERC721WithPermitUpgradable) {
        super._transfer(from_, to_, tokenId_);
    }

    function _baseURI() internal view override(ERC721Upgradeable, ERC721URIStorageUpgradeable) returns (string memory) {
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

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721Upgradeable, ERC721EnumerableUpgradeable, ERC721WithPermitUpgradable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
