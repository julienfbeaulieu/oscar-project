This shiny app explores data from the movies that were nominated in the
Oscar ceremonies.

Methodology
-----------

The original dataset which can be downloaded
[here]("https://www.aggdata.com/free_data_awards_locations/academy_awards"))lists
information about each nomination. Since an award can either go to a
film or to an artist, I processed the database to distinguish the two.

From this, a second dataset was created and takes the point of view of
each film . Number of academy nominations and awards were summed, and
extra information was pulled out using the [omdb
api]("http://www.omdbapi.com/").

datatables
----------

-   **rawdata.csv** is the original academy award database.
-   **oscar.csv** is the modified academy award database. **oscar.csv**
    is a subset that only list awarded nominees.
-   **movie.csv** gives information about each movie who was nominated
    directly or indirectly (i.e. through an actor) for an oscar.

R files
-------

-   **data\_processing.R** shows how the raw data was converted to the
    oscar.csv file.
-   **data\_processing\_movie.R** shows how information about each movie
    was extracted to make the movie.csv file.
-   **server.R** and **ui.R** are the two files that make up the Oscar
    Shiny application.
