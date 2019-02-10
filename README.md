
# The project

During their search for internships or first jobs, students face difficulties to organize the follow-up of their applications but also to find offers that really correspond to their criteria.

Beyond the fact that it is a stressful period for them, they often find themselves lost in the volume of offers available and the ambiguity of certain posts or missions, which can lead to to approximate choices.

Having met these different issues ourselves, we decided to develop a tool to facilitate the monitoring of these job offers. Our goal is to redirect the student to the offers that correspond to him the most according to the criteria he has previously entered on our platform.

The originality of the application lies on the one hand in the centralization of online offers for which the user has shown interest via a chrome extension. On the other hand, in its user-centric structure allowing it to efficiently sort its offers, to have a note of relevance relative to its criteria, as well as other features allowing it to have an overview in time and in the space of his opportunities

## The technology stack

### Backend

- Ruby 2.4.4
- Rails 5.2.1
- PostgreSQL
- Webpack 4.23.1
- Boostrap 4.1.3

### Database scheme
![capture](https://user-images.githubusercontent.com/30215564/52536434-c52edc80-2d5a-11e9-8cca-1fc0f8dfa487.PNG)

### Component libraries

- [Bootstrap-select](https://github.com/snapappointments/bootstrap-select) for multiple selects
- [Selectize](https://github.com/selectize/selectize.js) for places
- [Radar.js](https://www.chartjs.org/docs/latest/charts/radar.html) for Kiviat diagrams
- [Intro](https://github.com/usablica/intro.js) for introduction tutorial
- [List.js](https://github.com/javve/list.js) for searchable lists

## Styleguide

Styleguide page available [here](https://www.suricat.co/styleguide)

## Deployment

Before starting, make sure Ruby is installed on your system. Fire command prompt and run command:

```bash
ruby -v
```

Make sure Rails is installed:

```bash
rails -v
```

If you see Ruby and Rails version then you are good to start, other wise [setup Ruby on Rails](https://www.tutorialspoint.com/ruby-on-rails/rails-installation.htm)

Once done, you can install the application

1. Clone the repo

```bash
git clone https://github.com/leonard-henriquez/Suricat.git
```

2. Install all Ruby dependencies

```bash
bundle install
```

3. Install all Javascript dependencies

```bash
yarn install
```

4. Create db and migrate schema

```bash
rake db:drop
rake db:create
rake db:migrate
rake db:seed
```

5. Create your environnment

```bash
cp .env.default .env
```

Then, you should edit the file .env to reflect your configuration

6. Now run your application

```bash
rails s
```
