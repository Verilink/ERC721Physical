# ERC721 Physical by Verilink
## Overview
The purpose of this repository is to outline the ERC721Physical standard. ERC721Physical is an extension to the ERC721 standard that supports Physical NFTs. Physical NFTs are ERC721 tokens that are linked to a physical asset through a chip supporting cryptographic functions. Physical NFTs offer a link between physical and digital and allow unique applications due to this pairing. Providing a standard for "Physical NFTs" is critical to their success and adoption by allowing interoperability among platforms and features. Therefore, this document and repository provides the specifications and requirements for the ERC721Physical standard. 

## Chip Requirements
In order to support the ERC721Physical standard, the chip associated with the Physical NFT should fulfill the following minimum requirements. 
* Capable of cryptographically secure generation of asymmetric key pairs
* Capable of securely storing the private key of the asymmetric key pair with no interface
* Capable of signing messages from the private key of the asymmetric key pair
* Capable of retrieving the public key of the asymmetric key pair

Note: There are no restrictions on the asymmetric cryptographic algorithm, communication methods, or power requirements. The recommended chip is a passive device supporting NFC and secp256k1 ECC. For a supplier of these chips, check out [Kong](https://kong.land/).

## ERC721 Physical Specification
The ERC721 Physical Specification defines the interface and provides implementation guidelines.

### Interface

#### APIs
* `function chipId(uint256 tokenId) external view returns (bytes32)`
* `function isPhysical(uint256 tokenId) external view returns (bool)`
* `function isValidChipSignature(uint256 tokenId, bytes32 hash, bytes calldata signature) external view returns (bool)`

#### Requirements
##### chipId
This returns a representation of the public key of the chip associated with the ERC721Physical *tokenId*. The implementation will be based on the chip. For a concrete example, the public key representation could be `keccak256(publicKey)` or `uint160(keccak256(publicKey))`. There is no requirement for the representation function to have an inverse mapping back to public key. It should require *tokenId* exists. 

##### isPhysical
This returns whether *tokenId* supports ERC721Physical. This is important for supporting ERC721 contracts with a combination of physical NFTs and "vanilla" NFTs. It should require *tokenId* exists.

##### isValidChipSignature
This returns whether the *signature* is valid for the chip associated with *tokenId* given the *hash*. It should recover the signer from the signature and the hash and compare this to the representation of the public key of the chip associated with *tokenId*. The implementation will be based on the chip. Further specifications should be provided for individual chips to have consistency among the implementations. For example, the signature format may differ between chips. In our implementation `signature = concat([r, s, v])`.
