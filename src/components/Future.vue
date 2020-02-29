/* eslint-disable */
<template>
  <div class="page">

    <div style="height: 20px;"></div>


    <div class="md-layout md-gutter">

      <div class="md-layout-item">
        <md-card>
          <md-ripple>

            <md-card-header class="md-layout-item md-size-100">
              <md-card-header-text>
                <div class="md-title">Future tokens</div>
                <div class="md-subhead">
                  Check when your funds become available
                </div>
              </md-card-header-text>


            </md-card-header>


            <md-card-content>

              <md-table>
                <md-table-row>
                  <md-table-head>Currency</md-table-head>
                  <md-table-head>Total</md-table-head>
                  <md-table-head>Interests</md-table-head>
                  <md-table-head>I</md-table-head>
                  <md-table-head>II</md-table-head>
                  <md-table-head>III</md-table-head>
                  <md-table-head>IV</md-table-head>
                  <md-table-head>V</md-table-head>
                  <md-table-head>VI</md-table-head>
                  <md-table-head>VII</md-table-head>
                  <md-table-head>VIII</md-table-head>
                  <md-table-head>IX</md-table-head>
                  <md-table-head>X</md-table-head>
                  <md-table-head>XI</md-table-head>
                  <md-table-head>XII</md-table-head>
                </md-table-row>

                <md-table-row>
                  <md-table-cell>
                    <img src="https://testnet.aave.com/static/media/eth.1a64eee6.svg"
                         style="height: 24px; margin-right: 3px;"> ETH
                  </md-table-cell>
                  <md-table-cell><b>{{balances[12] && balances[12].toFixed(2)}}</b></md-table-cell>
                  <md-table-cell><b>{{balances[77] && balances[77].toFixed(5)}} (${{balances[77] && (balances[77]*223).toFixed(2)}})</b></md-table-cell>
                  <md-table-cell v-for="i in 12" :key="i">

                      <md-button class="md-fab md-mini" style="color: white;" v-if="balances[i - 1] > 0"
                                 @click="transfer(balances[i - 1], i-1)">
                        {{balances[i - 1]}}
                      </md-button>
                    <span v-else>-</span>
                  </md-table-cell>
                </md-table-row>

              <md-table-row>
                <md-table-cell>
                  <img src="https://testnet.aave.com/static/media/dai.59d423e0.svg"
                       style="height: 24px; float: left; margin-right: 3px; margin-top: -3px;"> DAI
                </md-table-cell>
                <md-table-cell><b>0</b></md-table-cell>
                <md-table-cell><b>0 ($0)</b></md-table-cell>
                <md-table-cell v-for="i in 12" :key="i">-</md-table-cell>
              </md-table-row>
              </md-table>


            </md-card-content>
          </md-ripple>
        </md-card>
      </div>
    </div>


    <md-dialog :md-active.sync="showTransferDialog">
      <md-dialog-title>Transfer</md-dialog-title>

      <md-tabs md-dynamic-height>
        <md-tab md-label="In space">
          <form novalidate>
            <div class="form-container">
              <md-field>
                <label for="spaceValue">Value (max: {{this.selectedMax}})</label>
                <md-input name="spaceValue" id="spaceValue" v-model="spaceValue" />
              </md-field>

              <md-field>
                <label for="spaceAddress">Target address</label>
                <md-input name="spaceAddress" id="spaceAddress" v-model="spaceAddress" />
              </md-field>
            </div>

            <md-button class="md-primary md-raised" @click="transferInSpace()">Transfer</md-button>
          </form>
        </md-tab>

        <md-tab md-label="In time">
          <p>Lorem ipsum dolor sit amet consectetur, adipisicing elit. Ullam mollitia dolorum dolores quae commodi impedit possimus qui, atque at voluptates cupiditate. Neque quae culpa suscipit praesentium inventore ducimus ipsa aut.</p>
          <p>Lorem ipsum dolor sit amet consectetur, adipisicing elit. Ullam mollitia dolorum dolores quae commodi impedit possimus qui, atque at voluptates cupiditate. Neque quae culpa suscipit praesentium inventore ducimus ipsa aut.</p>
          <p>Lorem ipsum dolor sit amet consectetur, adipisicing elit. Ullam mollitia dolorum dolores quae commodi impedit possimus qui, atque at voluptates cupiditate. Neque quae culpa suscipit praesentium inventore ducimus ipsa aut.</p>
          <p>Lorem ipsum dolor sit amet consectetur, adipisicing elit. Ullam mollitia dolorum dolores quae commodi impedit possimus qui, atque at voluptates cupiditate. Neque quae culpa suscipit praesentium inventore ducimus ipsa aut.</p>
          <p>Lorem ipsum dolor sit amet consectetur, adipisicing elit. Ullam mollitia dolorum dolores quae commodi impedit possimus qui, atque at voluptates cupiditate. Neque quae culpa suscipit praesentium inventore ducimus ipsa aut.</p>
        </md-tab>

      </md-tabs>
    </md-dialog>

    <md-dialog :md-active.sync="showSpaceTransferModal">
      <div class="container">
        <img src="https://i.giphy.com/media/xT8qB50yhFINpFTymI/giphy.webp" alt="Snow" style="width:100%;">
        <div class="top-left">Transferring your tokens in space ...</div>
      </div>
    </md-dialog>


  </div>
</template>

<script>
  import {getBalances, spaceTransfer} from '@/blockchain/futureToken'
  import {getLendingConfig, getReserveData} from '@/blockchain/aave'
  import {deployFutureCoin} from '@/blockchain/deployer'
  import RangeSlider from 'vue-range-slider'
  import 'vue-range-slider/dist/vue-range-slider.css'

  export default {
    name: 'Future',
    components: {
      RangeSlider
    },
    data() {
      return {
        balances: [],
        showTransferDialog: false,
        selectedMax: 0,
        selectedPeriod: 0,
        spaceAddress: "0x4a0d2F7d6F41c0D2AE424Ff240ca7A19cbe23dA3",
        spaceValue: 0,
        showSpaceTransferModal: false
      }
    },
    beforeCreate: async function () {
      this.balances = await getBalances();
    },
    methods: {
      transfer(val, period) {
        this.selectedMax = val;
        this.selectedPeriod = period;
        console.log("Transferring max: " + this.selectedMax + " from: " + this.selectedPeriod);
        this.showTransferDialog = true;
      },
      transferInSpace: async function () {
        console.log("Transferring in space: " + this.spaceValue + " to: " + this.spaceAddress);
        this.showTransferDialog = false;
        this.showSpaceTransferModal = true;
        await spaceTransfer(this.spaceAddress, this.selectedPeriod, this.spaceValue);
        this.showSpaceTransferModal = false;
        this.balances = await getBalances();
      }
    }
  }
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style lang="scss">

  div.page {
    padding: 0 20px 0 20px;
    width: 100%;
    height: 800px;
    text-align: center;
  }

  .text {
    font-size: 36px;
    padding: 30px 0 30px 0;
  }

  .dinput {
    width: 50px;
    border-bottom: 1px solid gray;
  }

  .slider {
    /* overwrite slider styles */
    width: 500px;
  }

  .md-table-cell-container {
    padding: 0 !important;
  }


</style>
