// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";

import { Base64 } from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string private baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    string[] private firstWords = ["curved", "loutish", "merciful", "lush", "helpful", "feeble", "materialistic", "necessary", "idiotic", "shrill", "dreary", "flagrant", "short", "craven", "mighty", "elastic", "receptive", "melodic", "early", "unhappy"];
    string[] private secondWords = ["shivering", "icy", "public", "busy", "acidic", "orange", "sassy", "impressive", "oafish", "disagreeable", "fancy", "deep", "feeble", "six", "gleaming", "familiar", "weak", "gratis", "berserk", "festive"];
    string[] private thirdWords = ["secretary", "director", "temperature", "data", "employment", "priority", "presence", "message", "vehicle", "thing", "year", "assistance", "girl", "length", "connection", "cousin", "hotel", "clothes", "memory", "student"];

    constructor() ERC721 ("SquareNFT", "SQUARE") {
        console.log("This is my NFT contract. Cool!");
    }

    function pickRandomFirstWord(uint256 _tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(_tokenId))));
        rand = rand % firstWords.length;
        return firstWords[rand];
    }

    function pickRandomSecondWord(uint256 _tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(_tokenId))));
        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    function pickRandomThirdWord(uint256 _tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(_tokenId))));
        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }

    function random(string memory _input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(_input)));
    }

    function makeAnEpicNFT() public {
        uint256 newItemId = _tokenIds.current();

        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);
        string memory combinedWord = string(abi.encodePacked(first, "_", second, "_", third));

        string memory finalSvg = string(abi.encodePacked(baseSvg, combinedWord, "</text></svg>"));

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        "{\"name\": \"",
                        combinedWord,
                        "\", \"description\": \"A highly acclaimed collection of squares.\", \"image\": \"data:image/svg+xml;base64,",
                        Base64.encode(bytes(finalSvg)),
                        "\"}"
                    )
                )
            )
        );

        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n--------------------");
        console.log(finalTokenUri);
        console.log("--------------------\n");

        _safeMint(msg.sender, newItemId);

        _setTokenURI(newItemId, finalTokenUri);

        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
        _tokenIds.increment();
    }
}
