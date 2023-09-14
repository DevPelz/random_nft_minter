// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CHIX is ERC721Enumerable, Ownable, VRFConsumerBaseV2 {
    enum char {
        name,
        experience,
        strength,
        durability,
        speed,
        color
    }

    // Goerli/chainlink vars for randommness based on network specifications
    // Chainlink VRF Variables
    VRFCoordinatorV2Interface private immutable i_vrfCoordinator;
    address private constant vrfCoordinatorV2 =
        0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D;
    uint64 private constant suscriptionId = 14214;
    bytes32 private constant gasLane =
        0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15;
    uint32 private constant callbackGasLimit = 2_500_000;
    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private constant NUM_WORDS = 1;

    // NFT variables
    uint256 public constant mintFee = 0.000001 ether;
    uint256 private _tokenCounter;
    uint256 internal constant MAX_TRAIT_VAL = 100;
    string[] internal _nftTokenUris;
    bool private _initialized;

    constructor(
        string[3333] memory nftTokenUris
    ) VRFConsumerBaseV2(vrfCoordinatorV2) ERC721("DigitalVistas", "DV") {
        i_vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinatorV2);
    }
}
