// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

contract ReturnsGarbageToken {
    /*///////////////////////////////////////////////////////////////
    //                            EVENTS                           //
    ///////////////////////////////////////////////////////////////*/

    event Transfer(address indexed from, address indexed to, uint256 amount);

    event Approval(address indexed owner, address indexed spender, uint256 amount);

    /*///////////////////////////////////////////////////////////////
    //                       METADATA STORAGE                      //
    ///////////////////////////////////////////////////////////////*/

    string public constant name = "ReturnsGarbageToken";

    string public constant symbol = "RGT";

    uint8 public constant decimals = 18;

    /*///////////////////////////////////////////////////////////////
    //                        ERC20 STORAGE                        //
    ///////////////////////////////////////////////////////////////*/

    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;

    mapping(address => mapping(address => uint256)) public allowance;

    /*///////////////////////////////////////////////////////////////
    //                        MOCK STORAGE                         //
    ///////////////////////////////////////////////////////////////*/

    bytes garbage;

    /*///////////////////////////////////////////////////////////////
    //                         CONSTRUCTOR                         //
    ///////////////////////////////////////////////////////////////*/

    constructor() {
        totalSupply = type(uint256).max;
        balanceOf[msg.sender] = type(uint256).max;
    }

    /*///////////////////////////////////////////////////////////////
    //                        ERC20 LOGIC                          //
    ///////////////////////////////////////////////////////////////*/

    function approve(address spender, uint256 amount) public virtual {
        allowance[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);

        bytes memory _garbage = garbage;

        assembly {
            return(add(_garbage, 32), mload(_garbage))
        }
    }

    function transfer(address to, uint256 amount) public virtual {
        balanceOf[msg.sender] -= amount;

        // Cannot overflow because the sum of all user
        // balances can't exceed the max uint256 value.
        unchecked {
            balanceOf[to] += amount;
        }

        emit Transfer(msg.sender, to, amount);

        bytes memory _garbage = garbage;

        assembly {
            return(add(_garbage, 32), mload(_garbage))
        }
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual {
        uint256 allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.

        if (allowed != type(uint256).max) allowance[from][msg.sender] = allowed - amount;

        balanceOf[from] -= amount;

        // Cannot overflow because the sum of all user
        // balances can't exceed the max uint256 value.
        unchecked {
            balanceOf[to] += amount;
        }

        emit Transfer(from, to, amount);

        bytes memory _garbage = garbage;

        assembly {
            return(add(_garbage, 32), mload(_garbage))
        }
    }

    /*///////////////////////////////////////////////////////////////
    //                        MOCK LOGIC                           //
    ///////////////////////////////////////////////////////////////*/

    function setGarbage(bytes memory _garbage) public virtual {
        garbage = _garbage;
    }
}
