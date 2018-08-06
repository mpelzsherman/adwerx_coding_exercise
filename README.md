# adwerx_coding_exercise

## To run the code
*install dependencies*

  `bundle`
  
*initialize database*

  `rake db:create`
  `rake db:migrate`
  
*fetch projects*

  `GITHUB_API_TOKEN=<your token> rake github:fetch`
  
*start app*

  `rails s`

*load the web page*

  http://localhost:3000/star_groups
  
## Discussion

### Why Rails?

I chose to use Rails for this exercise because:
- The generator support makes it easy to spin up a new project
- I wanted to demonstrate my familiarity with Rails

There's a lot of auto-generated stuff here that isn't needed, of course, but it sets up the project nicely for extension.

I like that any Rails developer will be familiar with the rake tasks for database setup and data fetching.

### Interesting bits of code

The most interesting code is the task for fetching the github repos, in lib/tasks/github.rake.
I'm using the octokit gem. I ran into some interesting challenges around the query syntax and pagination.
The filter for number of stars does seem to work as advertised - I am still getting repos with > 2000 stars .
Also, pagination seems to stop after the first page.

The SQL query in app/models/star_group.rb was the best way I could think of the segment the projects into increments
of 200 stars.

### Performance concerns
The rake task currently inserts one row at a time. This is very slow.
To optimize performance, I would look at doing MySQL bulk inserts.

Note that I've "memoized" @star_groups in app/controllers/star_groups_controller.rb to avoid executing the query on every page request.
Since that data doesn't change, there's no need to re-run the query.

