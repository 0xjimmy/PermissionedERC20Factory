// SPDX-License-Identifier: MIT

pragma solidity 0.8.1;

import './openzeppelin/Clones.sol';

interface ITokenInit { 
    function initialize(string memory name, string memory symbol, uint8 decimals, address owner, bool whitelistState) external; 
}

contract TokenFactory {

    address public tokenTemplate;

    constructor(address _tokenTemplate) {
        tokenTemplate = _tokenTemplate;
    }

    event CreateToken(string name, string symbol, uint8 decimals, address owner, bool whitelistState, address contractAddress);

    function createToken(string memory name, string memory symbol, uint8 decimals, address owner, bool whitelistState) public returns (address) {
        address tokenAddress = Clones.clone(tokenTemplate);
        ITokenInit(tokenAddress).initialize(name, symbol, decimals, owner, whitelistState);
        emit CreateToken(name, symbol, decimals, owner, whitelistState, tokenAddress);
        return tokenAddress; 
    }
}
