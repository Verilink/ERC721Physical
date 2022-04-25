pragma solidity ^0.8.5;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./IERC721Physical.sol";

/**
 * ERC721Physical Standard Abstract Class
 * Provides the base functionality required to conform with the interface
 * Doesn't provide full ERC721 functionality to be concrete class
 * allows overrides for further customization
 * This was implemented for Kong Halo Chip 2021 Edition
 */
abstract contract ERC721Physical is ERC721, IERC721Physical {

    /**
     * Mapping from tokenId to device address
     */
    mapping(uint256 => bytes32) _chipIds;

    /**
     * Sets the `_chipId` for the given `tokenId`
     * requires `tokenId` exists
     */
    function _setChipId(uint256 tokenId, bytes32 _chipId) internal virtual
    {
        require(_exists(tokenId), "ERC721:Physical: set device for non-existent token");
        _chipIds[tokenId] = _chipId;
    }

    /**
     * Hook to be called on minting an ERC721 Physical NFT
     * sets the `_chipId` for the given `tokenId`
     */
    function _onMint(uint256 tokenId, bytes32 _chipId) internal virtual
    {
        _setChipId(tokenId, _chipId);
    }

    /**
     * Returns the chipId associated with the `tokenId` 
     * requires `tokenId` exists
    */
    function chipId(uint256 tokenId) public view virtual override returns (bytes32)
    {
        require(isPhysical(tokenId), "ERC721:Physical: device query for non-physical token");
        return _chipIds[tokenId];
    }

    /**
     * Returns whether the `tokenId` is physical
     * fails if `tokenId` doesn't exist
     * supports Vanilla NFT + Physical NFT collections
     */
    function isPhysical(uint256 tokenId) public view virtual override returns (bool)
    {
        require(_exists(tokenId), "ERC721:Physical: query for non-existent token");
        return _chipIds[tokenId] != bytes32(0);
    }

    /**
     * Returns whether the `signature` is valid for the chip
     * associated with `tokenId` given the `hash`
     * Implementation will be based on the chip specification
     */
    function isValidChipSignature(uint256 tokenId, bytes32 hash, bytes calldata signature) public view virtual override returns (bool)
    {
        bytes32 _chipId;
        address signer;
        uint8 v;
        bytes32 s;
        bytes32 r;

        /* Implicitly requires isPhysical */
        _chipId = chipId(tokenId);

        /* Implementation for Kong Halo Chip 2021 Edition */
        require(signature.length == 65, "ERC721:Physical: invalid signature");

        /* unpack v, s, r */
        v = uint8(signature[64]);
        s = bytes32(signature[0:32]);
        r = bytes32(signature[32:64]);

        if(uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0)
        {
            revert("ERC721:Physical: invalid signature `s` value");
        }

        if(v != 27 && v != 28)
        {
            revert("ERC721:Physical: invalid signature `v` value");
        }

        signer = ecrecover(hash, v, r, s);
        
        require(signer != address(0x0), "ERC721:Physical: invalid signer");

        return signer == address(uint160(uint256(_chipId))); // get the last 20 bytes of the chipId
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
        return interfaceId == type(IERC721Physical).interfaceId || super.supportsInterface(interfaceId);
    }
}