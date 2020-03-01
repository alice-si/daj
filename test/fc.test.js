var FT = artifacts.require("FutureToken");


require("./test-setup");

contract('Future token', function ([owner, oracle, reserve, pool]) {
  var ft, currentPeriod;

  before("deploy future coin", async function () {
    ft = await FT.new(oracle, 1000, reserve, pool);
    //await ft.setInterestRates(1000, {from: oracle});
  });


  it("should calculate correct period", async function () {
    currentPeriod = await ft.getCurrentPeriod();
    currentPeriod.should.be.bignumber.equal("3");
  });


  it("should calculate warping prices", async function () {
    let base = 1000000000;
    let priceForward = await ft.getWarpPrice(base, 12, true);
    console.log("Price forward: " + priceForward);
    let priceBackward = await ft.getWarpPrice(base-priceForward, 12, false);
    console.log("Price forward: " + priceBackward);
  });


  it("should deposit in current period", async function () {
    (await ft.balanceOf(owner, 0)).should.be.bignumber.equal('0');

    let wei100 = web3.utils.toWei("100", 'ether');

    await ft.deposit(wei100, 0);

    (await ft.balanceOf(owner, 2)).should.be.bignumber.equal(wei100);
    (await ft.getTotalInterests()).should.be.bignumber.equal('0');
  });


  it("should withdraw money", async function () {
    let wei50 = web3.utils.toWei("50", 'ether');

    await ft.withdraw(wei50);

    (await ft.balanceOf(owner, 2)).should.be.bignumber.equal(wei50);
  });


  it("should warp money", async function () {
    let wei50 = web3.utils.toWei("50", 'ether');
    (await ft.getWarpPrice(wei50, 6)).should.be.bignumber.equal('2380952380952390000');

    await ft.warp(wei50, 2, 8);

    (await ft.balanceOf(owner, 2)).should.be.bignumber.equal('0');
    (await ft.getTotalInterests()).should.be.bignumber.equal('2380952380952390000');
    (await ft.balanceOf(owner, 8)).should.be.bignumber.equal(wei50);
  });


  it("should warp back money", async function () {
    let wei50 = web3.utils.toWei("50", 'ether');

    (await ft.getWarpPrice(wei50, 6)).should.be.bignumber.equal('2380952380952390000');

    await ft.warp(wei50, 8, 2);

    (await ft.balanceOf(owner, 2)).should.be.bignumber.equal(wei50);
    (await ft.getTotalInterests()).should.be.bignumber.equal('0');
    (await ft.balanceOf(owner, 8)).should.be.bignumber.equal('0');
  });

});



