pragma solidity ^0.5.0;


/******************
@title Calendar
@dev Simple library for months calculation
 */

library Calendar {

  uint256 internal constant YEAR_START = 1577836800;

  function getCurrentMonth() internal view returns (uint256) {
    return (now - YEAR_START) / 30 days + 1;
  }

}
