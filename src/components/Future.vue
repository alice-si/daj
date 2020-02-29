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
                  <md-table-cell v-for="i in 12" :key="i">{{balances[i - 1] == 0 ? '-' : balances[i - 1]}}</md-table-cell>
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


  </div>
</template>

<script>
  import {getBalances} from '@/blockchain/futureToken'
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
      }
    },
    beforeCreate: async function () {
      this.balances = await getBalances();
    },
    methods: {
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


</style>
