pragma solidity ^0.4.4;
import "./Crowdsale.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";


contract PreICO is Crowdsale {
  using SafeMath for uint256;
  uint256 public cap;
  bool public isFinalized;

  uint256 public minContribution = 100000000000000000; //0.1 ETH
  uint256 public maxContribution = 1000 ether;
  function PreICO(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _cap, address _wallet, address _token) public
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
    bool withinRange = msg.value >= minContribution && msg.value <= maxContribution;
    bool withinCap = weiRaised.add(msg.value) <= cap;
    return withinRange && withinCap && super.validPurchase();
  }

  function changeMinContribution(uint256 _minContribution) public onlyOwner {
    require(_minContribution > 0);
    minContribution = _minContribution;
  }

  function changeMaxContribution(uint256 _maxContribution) public onlyOwner {
    require(_maxContribution > 0);
    maxContribution = _maxContribution;
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
