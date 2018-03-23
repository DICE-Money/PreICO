pragma solidity ^0.4.4;
import "./Crowdsale.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";


contract PrivateSale is Crowdsale {
  using SafeMath for uint256;
  uint256 public cap;
  bool public isFinalized;
  function PrivateSale(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _cap, address _wallet, address _token) public
  Crowdsale(_startTime, _endTime, _rate, _wallet, _token)
  {
      cap = _cap;
  }

  function hasEnded() public view returns (bool) {
    bool capReached = weiRaised >= cap;
    return capReached || super.hasEnded();
  }

  // overriding Crowdsale#validPurchase to add extra cap logic
  // @return true if investors can buy at the moment
  function validPurchase() internal view returns (bool) {
    bool withinCap = weiRaised.add(msg.value) <= cap;
    return withinCap && super.validPurchase();
  }

  function finalize() onlyOwner public {
    require(!isFinalized);
    require(hasEnded());
    super.finalization();
    isFinalized = true;
  }

  function setNewWallet(address _newWallet) onlyOwner public {
    wallet = _newWallet;
  }

}
