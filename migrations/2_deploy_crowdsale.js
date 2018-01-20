var SimpleToken = artifacts.require('./SimpleToken');

var PreICO = artifacts.require('./PreICO');
var utils = require('./../deployment_utils');
var Promise = require('bluebird');

function ether(n) {
  return new web3.BigNumber(web3.toWei(n, 'ether'))
}

function latestTime() {
  return new Promise((resolve, reject) => {
    web3.eth.getBlock('latest', (err, block) => {
      console.log(err);
      if(err) reject(err);
      else resolve(block.timestamp);
    })
  })
}

const duration = {
  seconds: function(val) { return val},
  minutes: function(val) { return val * this.seconds(60) },
  hours:   function(val) { return val * this.minutes(60) },
  days:    function(val) { return val * this.hours(24) },
  weeks:   function(val) { return val * this.days(7) },
  years:   function(val) { return val * this.days(365)}
};

module.exports = async function (deployer) {


  var args = [];
  var params = [web3, SimpleToken.bytecode, SimpleToken.abi].concat(args);
  var gas = await utils.getSuggestedGasForContract.apply(utils, params);
  var deployArgs = [SimpleToken].concat(args);
  deployArgs.push({ gas: gas });
  deployer.deploy.apply(deployer, deployArgs).then(async () => {
      var startTime = await latestTime() + duration.minutes(2);
      var endTime = startTime + duration.days(2);
      var rate = 2000;
      var wallet = '0xFBb1E11614861003A2192641Af990CEcd12dCc92'
      var cap = ether(2500);
      var token = SimpleToken.address;
      //uint256 _startTime, uint256 _endTime, uint256 _rate,
      //address _wallet, address _token
      var args = [
        startTime,
        endTime,
        rate,
        '0x' + cap.toString(16),
        wallet,
        token
      ]
      var params = [web3, PreICO.bytecode, PreICO.abi].concat(args);
      var gas = await utils.getSuggestedGasForContract.apply(utils, params);
      var deployArgs = [PreICO].concat(args);
      deployArgs.push({ gas: gas });
      console.log(args);
      return deployer.deploy.apply(deployer, deployArgs).then(console.log)
  })
};
