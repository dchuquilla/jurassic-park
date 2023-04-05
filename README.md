# Jurassic Park API

This is a Ruby on Ruby 3.1.0 and Rails 7 API project that uses JWT, devise, and PostgreSQL for authentication and data storage.

## Installation

To set up this project, follow these steps:

1. Clone the repo:

```
git clone
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

5. Start the server:

```
rails s
```

## Usage

To use the API, you can send requests to the endpoints defined in config/routes.rb. For example, to create a new user, you can send a POST request to /api/v1/users with the following JSON in the request body:

```
{
  "user": {
    "email": "example@example.com",
    "password": "password"
  }
}
```

The API will return a JSON response with the newly created user's details and a JWT token that can be used for authentication in subsequent requests.
