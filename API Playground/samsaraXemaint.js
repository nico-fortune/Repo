const logger = require('./Exportables/util.js'),
    axios = require('axios'),
    samsara = require('api')('@samsara-dev-rel/v2019.01.01#fyom4jlahaar6d');
require('dotenv').config();

samsara.auth(process.env.SAMSARA);

logger('Sync', 'Syncing Samsara Odometer readings to eMaint');

let
    // Comma-separated list of vehicle IDs you want queried for stats
    vehicles = undefined,
    // Formatted vehicle stats with vehicle ID and odometer reading
    // stats = undefined;
    stats = [
        {
          id: '281474981910780',
          name: '862678',
          externalIds: {
            'samsara.serial': 'GNN3T75WHH',
            'samsara.vin': '3ALAC4DV3KDKT7377'
          },
          obdOdometerMeters: { time: '2023-01-03T22:48:11Z', value: 525970525 }
        },
        {
          id: '281474981910781',
          name: '193015',
          externalIds: {
            'samsara.serial': 'GCCM9XY7FT',
            'samsara.vin': '1FVACWFC1KHKF7365'
          },
          obdOdometerMeters: { time: '2023-01-04T18:50:20Z', value: 485299745 },
          gpsOdometerMeters: { time: '2023-01-04T18:46:45Z', value: 485253071 }
        },
        {
          id: '281474981910782',
          name: '295174',
          externalIds: {
            'samsara.serial': 'GHPDE7KXNB',
            'samsara.vin': 'JALCDW162L7K01920'
          },
          gpsOdometerMeters: { time: '2023-01-04T20:06:02Z', value: 25449848 }
        },
        {
          id: '281474982899107',
          name: '427525',
          externalIds: {
            'samsara.serial': 'G3H958Y8XR',
            'samsara.vin': '3ALACWFC0NDNM4792'
          },
          obdOdometerMeters: { time: '2023-01-04T16:09:14Z', value: 140161160 },
          gpsOdometerMeters: { time: '2023-01-04T16:04:45Z', value: 140153726 }
        }
      ],
    mondayIDs = [];


// samsara.getVehicleStats({types: 'obdOdometerMeters,gpsOdometerMeters'})
//     .then(({ data }) => {
//         stats = data.data;
//         console.log(stats.length);
//     });


async function pushVehicleStats() {
    stats.forEach(item => {
        // Determine which meter reading is larger (AKA more accurate)
        let meter = larger(item.obdOdometerMeters.value, item.gpsOdometerMeters.value);

        // Only attempt to push data if either meter reading has actual data
        if(meter) {
            const fetch = require('node-fetch')

            let board = '3752886309',
            meterColumn = 'numbers',
            idColumn = 'id',
            query = `mutation {change_column_value(item_id: 1234567890, board_id: ${board}, column_id: \"email9\", value: \"{\\\"text\\\":\\\"test@gmail.com\\\",\\\"email\\\":\\\"test@gmail.com\\\"}\") {id}}`

            axios.post('https://api.monday.com/v2', {
                headers: {'Authorization': process.env.MONDAY_API_TOKEN},
                data: { 'query': query }
            });

            fetch ("https://api.monday.com/v2", {
                method: 'post',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization' : 'YourSuperSecretAPIkey'
                },
                body: JSON.stringify({
                    'query' : query
                })
            })
            .then(res => {
                res.json();

            });
        }
    });
}

async function getMondayItemId() {
    query = `query {
        boards(ids:${board}) {
            items { id }
        } 
    }`;

    axios.post('https://api.monday.com/v2', {
        headers: {'Authorization': process.env.MONDAY_API_TOKEN},
        data: { 'query': query }
    });

    // TODO: MAP THE RETURN HERE TO AN OBJECT USING THE IDs AS KEYS, THEN ASSIGN THE METER READINGS AS VALUES TO MAKE THE BOARD POPULATION EASY
}