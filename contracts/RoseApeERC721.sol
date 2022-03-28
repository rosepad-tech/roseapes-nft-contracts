// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./ERC2981ContractWideRoyalties.sol";

contract RoseApe721 is ERC721URIStorage, ERC2981ContractWideRoyalties, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    string private _name;
    string private _symbol;
    uint256 public _maxSupply = 5555;
    uint256 private _totalSupply;
    
    uint256 public _whitelistSalePrice = 100 ether; // change later.
    uint256 public _publicSalePrice = 150 ether; // change later.
    uint256 royalty = 300;

    uint256 public _whitelistOwnershipLimit = 3;
    uint256 public _publicOwnershipLimit = 15;

    uint256 public _testPrice = 1; // for testing purposes only
    bool public testMode = false;
    bool public paused = false;
    bool public whitelistMode = true;
    bool public revealed = false;

    address public devTeam = 0x4A7cf0919703CA8d392241B7917d524536bAb143;
    string public baseURI = "ipfs://QmeRHqU4a68coNKLnnaQU9D9ogky1v9V3bN1ni9ysutaz9/";

    mapping(address => bool) public whitelisted;
    mapping(address => uint256[]) public userOwnedTokens;

    constructor(string memory name_ , string memory symbol_, uint256 royalty_) ERC721(name_, symbol_) {
        _name = name_;
        _symbol = symbol_;
        _setRoyalties(devTeam, royalty_);

    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    //  Public Mint
    function mint(uint256 qty) public payable virtual {

        require(!paused);
        require(msg.value >= 0, "Not enough ROSE sent; check price!");
        require(_tokenIdCounter.current() < _maxSupply);

        //  Whitelist mode. We will have a whitelist event. 
        if(whitelistMode) { 
            require(whitelisted[msg.sender], "Only whitelist participants are allowed during whitelist sale.");
            if (whitelisted[msg.sender] == true) {
                uint256 requiredAmount = qty * _whitelistSalePrice;
                uint256 arrayLength = userOwnedTokens[msg.sender].length;
                uint256 toBeTotal = arrayLength + qty;
                require(toBeTotal < (_whitelistOwnershipLimit + 1), "Maximum Holding for WL Event"); // only 3 allowed!
                require(msg.value >= requiredAmount, "Not enough ROSE sent; check price!");
            }
        } else {
            uint256 requiredAmount = qty * _publicSalePrice;
            uint256 arrayLength = userOwnedTokens[msg.sender].length;
            uint256 toBeTotal = arrayLength + qty;
            require(toBeTotal < (_publicOwnershipLimit + 1), "Maximum Holding for Public Event"); // only 15 allowed!
            require(msg.value >= requiredAmount, "Not enough ROSE sent; check price!");
        }

        //  Mint
        for (uint256 i = 1; i <= qty; i++) {
            _tokenIdCounter.increment();
            uint256 tokenId = _tokenIdCounter.current();
            userOwnedTokens[msg.sender].push(tokenId);
            _mint(msg.sender, tokenId);
        }
    }

    //  SafeMint for Dev Team
    function safeMint(address to) public onlyOwner {
        require(_tokenIdCounter.current() < _maxSupply);

        // increment
        _tokenIdCounter.increment();
        uint256 tokenId = _tokenIdCounter.current();
        _safeMint(to, tokenId + 1);
    }

    //  Set the TOKEN URI
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory baseURI_ = _baseURI();

        if (revealed) {
            return bytes(baseURI_).length > 0 ? string(abi.encodePacked(baseURI_, Strings.toString(tokenId), ".json")) : "";
        } else {
            return string(abi.encodePacked(baseURI_, "hidden.json"));
        }
    }

    //  Withdraw Rose
    function withdraw() payable public onlyOwner {
        payable(devTeam).transfer(address(this).balance);
    }

    //  Configuration changes
    function changeBaseURI(string memory baseURI_) public onlyOwner {
        baseURI = baseURI_;
    }

    function changeWhitelistSalePrice(uint256 whitelistSalePrice_) public onlyOwner {
        _whitelistSalePrice = whitelistSalePrice_;
    }

    function changePublicSalePrice(uint256 publicSalePrice_) public onlyOwner {
        _publicSalePrice = publicSalePrice_;
    }

    function changePublicOwnershipLimit(uint256 publicOwnershipLimit_) public onlyOwner {
        _publicOwnershipLimit = publicOwnershipLimit_;
    }

    function changeRoyalty(uint256 royalty_) public onlyOwner {
        royalty = royalty_;
        _setRoyalties(devTeam,royalty_);
    }

    function changeWhitelistOwnershipLimit(uint256 whitelistOwnershipLimit_) public onlyOwner {
        _whitelistOwnershipLimit = whitelistOwnershipLimit_;
    }

    function changeDevTeam(address devTeam_) public onlyOwner {
        devTeam = devTeam_;
    }

    function changeRevealed(bool _revealed) public onlyOwner {
        revealed = _revealed;
    }

    function pause(bool _state) public onlyOwner {
        paused = _state;
    }

    function setToTestMode(bool _testMode) public onlyOwner {
        testMode = _testMode;
    }

    //  whitelist functions

    function changeWhitelistMode(bool _whitelistMode) public onlyOwner {
        whitelistMode = _whitelistMode;
    }


    function whitelistUser(address _user) public onlyOwner {
        whitelisted[_user] = true;
    }

    function isUserWhitelisted(address _user) public view returns (bool) {
        if(whitelisted[_user]==true) {
            return true;
        }
        return false;
    }

    function setWhitelist(address[] calldata _users) public onlyOwner {
        for (uint i = 0; i < _users.length; i++) {
            whitelisted[_users[i]] = true;
        }
    }

    function removeWhiteListUser(address _user) public onlyOwner {
        whitelisted[_user] = false;
    }

    function getNumberOfTokens(address _user) public view returns(uint256) {
        return userOwnedTokens[_user].length;
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721, ERC2981Base)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    /// @notice Allows to set the royalties on the contract
    /// @dev This function in a real contract should be protected with a onlyOwner (or equivalent) modifier
    /// @param recipient the royalties recipient
    /// @param value royalties value (between 0 and 10000)
    function setRoyalties(address recipient, uint256 value) public onlyOwner {
        _setRoyalties(recipient, value);
    }

}