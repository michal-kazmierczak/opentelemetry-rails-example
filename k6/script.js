import http from 'k6/http';

export default function () {
  // in every iteration the odds of an endpoint being called are:
  //  - 60% for "/demo/database_bulk_read"
  //  - 30% for "/demo/database_bulk_insert"
  //  - 10% for "/demo/database_delete_all"

  const chance = Math.random();
  switch (true) {
    case (chance < 0.6):
      var endpoint = '/demo/database_bulk_read';
      break;
    case (chance < 0.9):
      var endpoint = '/demo/database_sequential_insert';
      break;
    default:
      var endpoint = '/demo/database_delete_all';
  }

  http.get('http://localhost:3000' + endpoint);
}
