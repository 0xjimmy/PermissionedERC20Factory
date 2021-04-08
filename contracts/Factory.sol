// SPDX-License-Identifier: MIT

pragma solidity 0.8.1;

import './Token.sol';

contract TokenFactory {

    event CreateToken(string name, string symbol, address owner, bool whitelistState, address contractAddress);

    function createToken(string memory name, string memory symbol, address owner, bool whitelistState) public returns (address) {
        Token _token = new Token(name, symbol, owner, whitelistState);
        emit CreateToken(name, symbol, owner, whitelistState, address(_token));
        return address(_token); 
    }
}
