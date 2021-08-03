import http from 'k6/http'
import { sleep } from 'k6'

export const options = {
  ext: {
    loadimpact: {
      projectID: 3546421,
      // Test runs with the same name groups test runs together
      name: 'Frankfurt Local Stress'
    }
  },
  stages: [
    { duration: '1m', target: 50 }, // ramp up to 50 in 1 minute
    { duration: '5m', target: 50 } // stay at 50 for 5 minutes

    // { duration: '5s', target: 100 } // canary
    // { duration: '1m', target: 50 } // below normal load
    // { duration: '5m', target: 100 },
    // { duration: '2m', target: 200 }, // normal load
    // { duration: '5m', target: 200 },
    // { duration: '2m', target: 300 }, // around the breaking point
    // { duration: '5m', target: 300 },
    // { duration: '2m', target: 400 }, // beyond the breaking point
    // { duration: '5m', target: 400 },
    // { duration: '10m', target: 0 } // scale down. Recovery stage.
  ]
}

export default function () {
  const BASE_URL = 'http://localhost:3000' // make sure this is not production

  http.batch([
    [
      'GET',
      `${BASE_URL}/latest`,
      null,
      { tags: { name: 'Latest' } }
    ],
    [
      'GET',
      `${BASE_URL}/latest?amount=10&from=SEK&to=EUR`,
      null,
      { tags: { name: 'Convert' } }
    ],
    [
      'GET',
      `${BASE_URL}/latest?to=SEK,NOK`,
      null,
      { tags: { name: 'LatestToSEKNOK' } }
    ],
    [
      'GET',
      `${BASE_URL}/2020-05-12`,
      null,
      { tags: { name: 'Historical' } }
    ]
  ])

  sleep(1)
}
