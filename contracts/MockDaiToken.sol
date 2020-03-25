pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol";

/**
 * @title Mock DAI ERC20 AToken
 *
 * @dev A mock token to test protocol behavious
 */
contract MockDaiToken is ERC20, ERC20Detailed {

  constructor() public ERC20Detailed("MockDai", "DAI", 18) {
  }


 /**
 * It's a mock token so minting is public
 */
  function mint(address account, uint256 amount) public {
    _mint(account, amount);
  }

}
