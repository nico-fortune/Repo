const axios = require('axios'),
    samsara = require('api')('@samsara-dev-rel/v2019.01.01#fyom4jlahaar6d');
require('dotenv').config();

samsara.auth(process.env.SAMSARA);

// logger('Sync', 'Syncing Samsara Odometer readings to eMaint');


let
    // Comma-separated list of vehicle IDs you want queried for stats
    vehicles = undefined,
    // Formatted vehicle stats with vehicle ID and odometer reading
    stats = undefined,
    data = process.env.EMAINT,
    buff = new Buffer(data),
    encoded = buff.toString('base64');
const eMaint_Headers = {
  'Content-Type': 'application/json',
  'Authorization': encoded
};


    // stats = [
    //     {
    //       id: '281474981910780',
    //       name: '862678',
    //       externalIds: {
    //         'samsara.serial': 'GNN3T75WHH',
    //         'samsara.vin': '3ALAC4DV3KDKT7377'
    //       },
    //       obdOdometerMeters: { time: '2023-01-03T22:48:11Z', value: 525970525 }
    //     },
    //     {
    //       id: '281474981910781',
    //       name: '193015',
    //       externalIds: {
    //         'samsara.serial': 'GCCM9XY7FT',
    //         'samsara.vin': '1FVACWFC1KHKF7365'
    //       },
    //       obdOdometerMeters: { time: '2023-01-04T18:50:20Z', value: 485299745 },
    //       gpsOdometerMeters: { time: '2023-01-04T18:46:45Z', value: 485253071 }
    //     },
    //     {
    //       id: '281474981910782',
    //       name: '295174',
    //       externalIds: {
    //         'samsara.serial': 'GHPDE7KXNB',
    //         'samsara.vin': 'JALCDW162L7K01920'
    //       },
    //       gpsOdometerMeters: { time: '2023-01-04T20:06:02Z', value: 25449848 }
    //     },
    //     {
    //       id: '281474982899107',
    //       name: '427525',
    //       externalIds: {
    //         'samsara.serial': 'G3H958Y8XR',
    //         'samsara.vin': '3ALACWFC0NDNM4792'
    //       },
    //       obdOdometerMeters: { time: '2023-01-04T16:09:14Z', value: 140161160 },
    //       gpsOdometerMeters: { time: '2023-01-04T16:04:45Z', value: 140153726 }
    //     }
    //   ];


samsara.getVehicleStats({types: 'obdOdometerMeters'})
    .then(({ data }) => {
        stats = data.data;
        console.log(stats.length);
    })
    .catch(err => {
      console.log(err);
    });


async function pushVehicleStats() {
    stats.forEach(item => {
        // Determine which meter reading is larger (AKA more accurate)
        let meter = item.obdOdometerMeters.value,
          vin = item.externalIds.samsara.vin;

        // Only attempt to push data if either meter reading has actual data
        if(meter) {
            
        }
    });
}

async function getEmaintIds(vehicles) {
  // TODO:
  // * Change VIN in emaint to a dropdown
  // * Search for VIN
  // * Map actual asset ID to VIN
  // * match on VIN and import
  let ids = [],
    body = `{
      "select": [
          {
              "name": "serialNumber"
          }
      ],
      "filter": {},
      "order": [
          {
              "name": "serialNumber",
              "desc": true
          }
      ],
      "pageSize": 20,
      "page": 0,
      "fkExpansion": true
  }`;

  axios.post('https://fortunefishandgourmet/api/entities/def/Assets/search-paged',eMaint_Headers, {

  });

  return ids;
}