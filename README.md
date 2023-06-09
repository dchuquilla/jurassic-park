# Jurassic Park API

This is a Ruby on Ruby 3.1.0 and Rails 7 API project that uses JWT, devise, and PostgreSQL for authentication and data storage.

## Installation

To set up this project, follow these steps:

1. Clone the repo:

```
git clone git@github.com:dchuquilla/jurassic-park.git
```

2. Create ENV vars

```

 export DEVISE_JWT_SECRET_KEY=********
 export DEVISE_SECRET_KEY=********
 export DB_USER=********@***.com
 export DB_PASSWORD='********'
```

3. Install dependencies:

```
bundle install
```

4. Configure database:

```
rails db:create
rails db:migrate
```

5. Test the project:

```
bin/rspec
```

6. Start the server:

```
bin/rails s
```

## Usage (thanks to Postman)

To use the API, you can send requests to the endpoints defined in config/routes.rb. For example, to create a new user, you can send a POST request to /api/v1/users with the following JSON in the request body:

### Authorization

JWT Bearer

#### Cages

---

## GET

list cages

```
http://localhost:3000/api/v1/cages
```

---

## GET

show cage

```
http://localhost:3000/api/v1/cages/2
```

---

## POST

create request

```
http://localhost:3000/api/v1/cages
```

### Body

```JSON
{
  "cage": {
    "name": "Cage 1",
    "capacity": 10,
    "power_status": "active"
  }
}
```

---

## PUT

update Cage

```
http://localhost:3000/api/v1/cages/2
```

### Body

```JSON
{
  "cage": {
    "name": "Cage 3",
    "capacity": 2,
    "power_status": "down"
  }
}
```

---

## DELETE

delete Cage

```
http://localhost:3000/api/v1/cages/1
```

--

## GET

get Dinasours

```
http://localhost:3000/api/v1/cages/2/dinosaurs
```

The API will return a JSON response with the newly created user's details and a JWT token that can be used for authentication in subsequent requests.

## Pendings

- [ ] Dinosaurs controller tests
- [ ] Dinosaurs controller
- [ ] Dinosaurs endppint tests in postman
