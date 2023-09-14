// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";

contract CHIX is ERC721URIStorage, VRFConsumerBaseV2, Ownable {
    struct Char {
        uint intelligence;
        uint experience;
        uint strength;
        uint durability;
        uint speed;
        uint co;
    }

    Char[] internal characters;

    struct RequestStatus {
        bool fulfilled;
        bool exists;
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
    uint32 private constant NUM_OF_TRAITS = 1;

    // NFT variables
    uint256 public constant mintFee = 0.000001 ether;
    uint256 private _tokenCounter;
    uint256 internal constant MAX_TRAIT_VAL = 100;
    string[] internal nftTokenUris;
    bool private _initialized;

    // mapping to give each person a unique Id
    mapping(uint256 => address) public _IdToSender;

    //mapping to request status
    mapping(uint256 => RequestStatus) _requests;

    // past request
    uint256[] public requestsIds;

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

    function requestRandomNft() external payable returns (uint256 Id) {
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

    function fulfillRandomWords(
        uint256 requestId,
        uint256[] memory randomWords
    ) internal override {
        address nftOwner = _IdToSender[requestId];

        uint randomNumber = randomWords[0];
        uint tokenId = characters.length;

        uint intelligence = ((randomNumber % 100) % 18);
        uint experience = (((randomNumber % 10000) / 100) % 18);
        uint strength = (((randomNumber % 1000000) / 10000) % 18);
        uint durability = (((randomNumber % 100000000) / 1000000) % 18);
        uint speed = (((randomNumber % 10000000000) / 100000000) % 18);
        uint combat = (((randomNumber % 1000000000000) / 10000000000) % 18);

        characters.push(
            Char(intelligence, experience, strength, durability, speed, combat)
        );

        _safeMint(nftOwner, tokenId);
    }
}
