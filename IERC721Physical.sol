pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

/**
 * ERC721Physical Standard Interface
 * The chipId is a representation of the public key of the chip associated
 * with a token. This creates an immutable link between physical and digital.
 */
interface IERC721Physical is IERC721 {

    /**
     * Returns a representation of the public key of the chip associated with the `tokenId` 
     * fails if `tokenId` does not exist
     */
    function chipId(uint256 tokenId) external view returns (bytes32);

    /**
     * Returns whether the `tokenId` is physical
     * fails if `tokenId` does not exist
     */
    function isPhysical(uint256 tokenId) external view returns (bool);

    /**
     * Returns whether the `signature` is valid for the chip
     * associated with `tokenId` given the `hash`
     * Implementation will be based on the chip specification
     */
    function isValidChipSignature(uint256 tokenId, bytes32 hash, bytes calldata signature) external view returns (bool);
}