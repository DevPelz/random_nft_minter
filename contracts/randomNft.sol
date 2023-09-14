// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";

contract CHIX is ERC721URIStorage, VRFConsumerBaseV2, Ownable {
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
    uint32 private constant NUM_OF_TRAITS = 6;

    // NFT variables
    uint256 public constant mintFee = 0.000001 ether;
    uint256 private _tokenCounter;
    uint256 internal constant MAX_TRAIT_VAL = 100;
    string[] internal nftTokenUris;
    bool private _initialized;

    // mapping to give each person a unique Id
    mapping(uint256 => address) public _IdToSender;

    constructor(
        string[10] memory _nftTokenUris
    ) VRFConsumerBaseV2(vrfCoordinatorV2) ERC721("DigitalVistas", "DV") {
        i_vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinatorV2);
        _initializeContract(_nftTokenUris);
        _tokenCounter = 0;
    }

    function _initializeContract(string[10] memory _nftTokenUris) private {
        if (_initialized == true) {
            revert("Already Initialized");
        }
        nftTokenUris = _nftTokenUris;
        _initialized = true;
    }

    function mintNft() external payable returns (uint256 Id) {
        if (msg.value < mintFee) {
            revert("Not enought money to mint Nft");
        }
        Id = i_vrfCoordinator.requestRandomWords(
            gasLane,
            suscriptionId,
            REQUEST_CONFIRMATIONS,
            callbackGasLimit,
            NUM_OF_TRAITS
        );

        // set the Id of the sender;

        _IdToSender[Id] = msg.sender;
    }
}
