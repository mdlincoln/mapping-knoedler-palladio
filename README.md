# Critical Data Visualization with Palladio

[*Matthew Lincoln*](https://matthewlincoln.net)

## Foreword

The following lesson was made for Yael Rice's Fall 2020 digital art history course at Amherst College, September 18th, 2020.

It is the most recent iteration of a workshop that has been presented at venues including:

- Princeton's Department of Art History and Archaeology, October 18th, 2019.
- The [Networked Curator workshop given at the Getty Research Institute, February 8th, 2018](http://networkedcurator.doingdh.org/).
- The [Frick Digital Art History Lab, April 8th, 2016][amsterdam_palladio].

[amsterdam_palladio]: https://matthewlincoln.net/2016/04/07/exploring-depictions-of-amsterdam-with-palladio.html

You can see the full change history of this walkthrough at <https://github.com/mdlincoln/mapping-knoedler-palladio>

## Introduction to Palladio

[Palladio](https://hdlab.stanford.edu/palladio/) is a simple but powerful exploratory data visualization tool built at Stanford University. It runs entirely inside your internet browser. You don't need a user account, and none of the data you visualize ever leaves your computer. Although it is simple and has some limitations especially with large datasets, it has some very useful features for exploring a new data set and finding its oddities and eccentricities. It is a good intro way to look through a dataset and figure out what might be missing before moving on to more comprehensive tools like Tableau, Python, or R.

This walkthrough will take you step by step through several tasks in Palladio that you can do on your own before the class meeting. Each step includes a series of reflection questions, both about what we think the data could be telling us, but also what might be missing or mis-represented in the data. This exercise is more about learning how to use Palladio to **critically investigate data generated from historical documents** than it is about finding new historical insights. You will also likely come up with questions about the data that don't seem to be answered by the data documentation in this lesson. This is a real-life situation you'll find yourself in when working with data produced by others. **Figuring out what questions you would like to ask of the original data producers is a crucial part of critical data investigation.**

Make sure to record answers to these questions in a word document or notebook to have available for our discussion during class.

Some practical tips from [Miriam Posner](http://miriamposner.com/blog/getting-started-with-palladio/) before we begin:

>A reminder that Palladio is still under development, so it can be buggy
and slow!
>
>-   Work slowly. Wait for an option to finish loading before you click it again or click something else.
>
>-   **Do not refresh the page or click the back button.** You'll lose your work.
>
>-   On a related note: To start over, refresh the page.

Some additional tips from me:

**You need to run this on a full desktop or laptop computer - it doesn't work well with a touch screen!**

**Unfortunately, Palladio doesn't entirely work with Firefox, especially the dynamic map visualizations. The Chrome internet browser seems to have the best performance for Palladio, however Safari functions as well.**

## Introduction to the workshop data

<a href="https://matthewlincoln.net/mapping-knoedler-palladio/nyc_knoedler.csv" download="nyc_knoedler.csv">Download the CSV file that we'll work with.</a>

These data describe a little over 4,100 sales by the fine art dealer M. Knoedler & Co. between roughly 1870-1970, as documented in data encoded from the handwritten stockbooks by staff at the [Getty Provenance Index](http://www.getty.edu/research/tools/provenance/search.html).
These stockbooks were where Knoedler recorded details about the artworks that entered their inventory, when and where they bought them from and for how much, and (if sold) who the eventual buyer was.

Before forging ahead with the rest of the walkthrough, read the following essays on the Knoedler archive at the Getty, and the data project to encode the stockbooks, which are a small part of the full archive of Knoedler's business documents:

- <http://www.getty.edu/research/special_collections/notable/knoedler.html>
- <http://blogs.getty.edu/iris/database-of-knoedler-gallery-stock-books-now-online/>

In order to keep this introductory lesson straightforward and within the performance limits of Palladio, **this is only a tiny slice** of the [full Knoedler data, which cover over 40,000 entries](https://github.com/thegetty/provenance-index-csv/tree/master/knoedler).
The data in `nyc_knoedler.csv` covers only those cases in which:

1. The transactions were _actually recorded_ in the Knoedler stockbooks (they didn't always keep good records!)
2. The records contain original purchase _and_ sale dates and prices.
3. We have been able to identify both the buyer and the seller.
4. The buyer has a known street address located in Manhattan or Brooklyn (i.e. if our only location info says "New York, NY", it is not included in this subset because it doesn't contain street-level precision. **Note: as of the date that I produced this extracted sample, the Getty Provenance Index staff hadn't yet finished entering all the addresses that were originally recorded in the stockbooks - bear this in mind when interpreting visualizations!**)

Filtering the original 40,000+ entries based on these criteria results in the ~4,100 entries in the dataset we will use for this exercise.

I've also enhanced these data with some important modifications that aren't included in the original Knoedler data:

1. Imputed values for partially-recorded purchase and sale dates, based on location in the archive (for example, if the record is missing a date, but we know that the portion of the stockbook is recording sales from March 1902, then we could confidently state that the sale date took place between March 1st and March 31st of 1902.)
2. To allow comparison of prices over time, we've converted monetary amounts from foreign currencies into USD, and adjusted it to a dollar value pinned to 1900.[^conversion]
3. Generated lat/lon coordinates from the recorded street addresses using the [DSK geocoding service](http://www.datasciencetoolkit.org/).

[^conversion]: Dr. Sandra van Ginhoven led this work, relying predominantly on Markus A. Denzel's _Handbook of World Exchange Rates, 1590-1914_ (Burlington: Ashgate, 2010) for currency conversion, and Samuel H. Williamson's resource “Annual Consumer Price Index for the United States, 1774-2014,” (2016) <https://www.measuringworth.com/uscpi/result.php> to adjust prices based on US CPI.

For the sake of simplicity, I've drastically trimmed the number of variables for each of these transactions.
This means some complexities that _are_ represented in the Knoedler data, like transactions of multiple objects, as well as joint purchases by Knoedler and another dealer, are flattened here.

### Data dictionary

| field                | description                                                                                                                                                                                                                                                                                 |
| -------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `title`              | Title of the work (if recorded)                                                                                                                                                                                                                                                             |
| `artists`            | Creator(s) of the artwork (if recorded. GPI edtiors recorded the original spelling as written by Knoedler, but also recorded a standardized version if they could identify the artist [e.g. turning "J. Sargent" into "SARGENT, JOHN SINGER"]. This field holds the standardized versions.) |
| `artist_nationality` | Creator(s) nationalities (input by modern editors)                                                                                                                                                                                                                                          |
| `genre`              | Genre of the work (input by modern editors)                                                                                                                                                                                                                                                 |
| `object_type`        | e.g. `Painting`, `Drawing`, `Sculpture` (input by modern editors)                                                                                                                                                                                                                           |
| `height`             | Height in inches (if recorded)                                                                                                                                                                                                                                                              |
| `width`              | Width in inches (if recorded)                                                                                                                                                                                                                                                               |
| `area`               | Area in square inches (if recorded)                                                                                                                                                                                                                                                         |
| `seller`             | Name of seller (Standardized in a similar manner to the artists. Numeric ID if anonymous/unknown)                                                                                                                                                                                           |
| `seller_type`        | e.g. `Dealer`, `Museum`, `Artist`, `Collector`                                                                                                                                                                                                                                              |
| `buyer`              | Name of buyer (Standardized in a similar manner to the artists. Numeric ID if anonymous/unknown)                                                                                                                                                                                            |
| `buyer_type`         | e.g. `Dealer`, `Museum`, `Artist`, `Collector`                                                                                                                                                                                                                                              |
| `buyer_address`      | Buyer address                                                                                                                                                                                                                                                                               |
| `coordinates`        | Coordinates in the format `lat,lon`                                                                                                                                                                                                                                                         |
| `purchase_date`      | Date object brought into Knoedler stock in the format `YYYY-MM-DD`                                                                                                                                                                                                                          |
| `sale_date`          | Date object sold out of Knoedler stock in the format `YYYY-MM-DD`                                                                                                                                                                                                                           |
| `purchase_price`     | Price Knoedler paid to buy the object (normalized to 1900 USD)                                                                                                                                                                                                                              |
| `sale_price`         | Price Knoedler received for selling the object (normalized to 1900 USD)                                                                                                                                                                                                                     |


### Reflection questions

The dataset we are using is several degrees removed from the original historical events of Knoedler's sales and purchases of artworks. Based on all the description here, reflect on what information might be lost at each of these stages.

(I suggest you make some initial notes based on what you've read so far, then return to these questions after you have finished the rest of the walkthrough in order to add more examples that jump out once you start to visualize the data):

1. The filtering and data enhancement I did to produce our walkthrough data was quite restrictive. What kinds of art historical questions would we need to rule out asking based on what we know about way I filtered the full dataset entered by the GPI staff?
2. The "original" data that I started with was still produced in the 21st century by editors at the GPI who looked at the original handwritten books. What kinds of normalization did those editors do? How could that affect the kinds of questions we can responsibly ask of these data?
3. What actually occurred in real life and what Knoedler's staff recorded in their stock books might differ. Consider the individual fields described in the data dictionary - which of those could be subject not only to the GPI staff's interpretation, but also to _Knoedler's_ interpretation back when their staff produced the records in the first place? How does that further impact the way we think about these data?

## Loading our data

Navigate to <https://hdlab.stanford.edu/palladio/> and click on the "Start" button.

Find the `nyc_knoedler.csv` file that you donwloaded to your computer, and drag it into the window where it says "Load .csv or spreadsheet". You should see text fill the box. Click the "Load" button below.

You should now see the data loaded into Palladio, represented as a list of all the field names in the original CSV, with 4193. rows. Where it says "Provide a title to this project", let's name it "Knoedler", where the table name says "Untitled", write in "New York Sales".

## Checking our data

The data view shows the fields (i.e. columns) from our spreadsheet, and also shows what type of variable Palladio has guessed our data are supposed to be. We've got a few text fields here, as well as date fields, and a coordinates field.

Palladio tries to check for some simple irregularities in our data, like odd characters, and it's highlighted those fields with a red dot. We can ignore most of these for now, as almost all those characters (like commas or dashes in the _title_ field) are there on purpose.

That said, there are some exceptions. Click on the `artists` label to inspect the data in that field. Palladio will show a list of all the unique values in that field, and the number of times that value shows up in the records. Across 4193 total records, there are only a little over 1,000 unique values in the `artists` field.

You'll notice an option to insert a **delimiter** - a character that Palladio can use to split the `artists` field if it contains multiple artists. If you click on the special characters above the multiple values box, you can filter the values at left to look at the ones containing commas, semicolons, and hyphens. Figure out which one of those characters the GPI data uses to denote multiple different artists, and enter it into the multiple values box, then click "Close".

You'll need to also specify a delimiter for the `genre` field. Repeat the same steps as you took for the `artists` field.

### Reflection questions

1. Search the `artist` values to look for text contained inside brackets `[]`. These aren't individual names, but categories instead. What kinds of categories do you see and what might explain their presence in the original data? How would we need to think carefully about counting or measuring these categories compared to individual artist names?

## Creating a table

Usually the first thing to do in Palladio is to go to the "Table" tab, where you can view the underlying records themselves and start to experiment with the different filters.

Once you click on the "Table" tab, go to the "Settings" in the upper right and select the "row" dimension - in our case, pick the field called `generated` - this is a field that Palladio added to our original data and represents the row number in the original CSV.

Under "Dimensions" you can select several or all of the original CSV values to view in the table. To start, let's add `title`, `artists`, `artist_nationality`, `genre`, `object_type`, `purchase_price`, and `sale_price`.

You should now see a spreadsheet of the selected fields.

### Filtering by facet

Now we can start "faceting", or filtering the data based on different categorical variables, like buyer name or artist nationality. Click on the "Facet" button on the lower left corner, and in the lower right corner, use the "Dimensions" menu to select which variable we want to facet by. Let's start with `artist_nationality`. The facet bar will count up all the occurrences of each artist nationality and rank them. If you click on a single facet value, it will filter down the displayed table to only show that facet. Try looking through the artists and titles where the `artist_nationality` is `American`.

If you click again on the "Dimensions" box at right, you can add additional fields to do compound faceting, such as listing all the works with the `genre` of `landscape` by American artists.

### Filtering by Timeline

We can also click on the "Timeline" filter to visualize and filter based on date. Palladio should already have recognized the `purchase_date` column and created a timeline historgram for us. This is the date that the Knoedler gallery recorded purchasing the painting and adding it to their stock. You can drag and select a particular range if you like, and then drag that range around to dynamically update the table to show only the sales within the selected time span.

By default, the "Height" of the bars is based on the number of sale records in table at that date. But we can change it to instead reflect the sum of some numeric variable, like purchase price, sale price, or even the size of the artworks that we calculated based off their recorded height and width.

Experiment with this and see how these trends compare to what we see in the plain numbers of works that Knoedler sold.
Leaving the current timeline open, click on the "Timeline" button again to add a second one and try a different height metric to compare.
The "group by" field will tint the bars so you can further subdivide the timeline. Try this on categorical variables like `artist_nationality` or `object_type`.

Palladio also understands _timespans_, or activities that have a start and end date. After dismissing the Timeline filter with the red trash basket button, click on "Timespan". We'll need to tell it the correct start date (`purchase_date`) and end date (`sale_date`) columns. Now in addition to getting a map visualization, we'll also be able to visualize the tempo at which Knoedler purchased and then sold their stock. You can experiment with different timespan visualization techniques by changing the "Layout" menu.

### Reflection Questions

1. How did the volume of individual sales per year change over this period? Contrast that to the sum of sale prices per year - Knoedler's raw revenue. What differences do you notice? What questions does this suggest about the changing nature of Knoedler's art dealing business?
2. Using the "Group by" field, look for trends in the `genre` or `object_type` that Knoedler sold over this time period - both in terms of number of sales, summed prices, or even size of artworks. Try some combinations - what patterns do you notice?
    - Based on the descriptions of `genre` and `object_type` in the data dictionary above, what caveats should we keep in mind when looking at visualizations of those categories?
4. Are there any sudden drops or gaps in these data that could instead be associated with historical events between 1870-1970? Could any of those gaps point to data entry problems? What would we need to do in order to distinguish between them?

## Create a map

Now click on the "Map" button. Palladio starts you out with a plain coastline base map. Before adding our own data, we can enhance this base map by adding more "Tiles". Click on "New Layer", then click on the "Tiles" tab. You can see the different tile types to add to the base map - let's add "Streets" by clicking on the "Streets" button. In the "Name" field above, type "Streets", then click "Add Layer". You should now see borders and cities showing up on your base map.

Now it's time to add our own data. Click on "New Layer" again, and click the "Data" tab. We'll be adding "Points" (the default option). Under the name, type "Sales Locations". Click on "Places" and select `coordinates` (the only option available, since this is the only data in our table that is formatted as a pair of coordinates). For the tooltip label (what we see when we roll over the points), let's start with `buyer_address`.

Check the box to size points, and do so according to `number of New York Sales`, which will make points bigger when they match more rows in our table. Finish by clicking "Add Layer", and then click on the hamburger button (the three small lines in the upper right corner) to minimize the layer configuration box.

You should see a few dots appearing over New York City. In the upper left corner, underneath the zoom in/out buttons, there's a small button with a few nested squares, called "Zoom to data" - click on this to automatically zoom in so that our data points fill the screen.

Roll over the points to inspect the addresses matched to each one. Look for the particularly huge points - what do you notice about the list of addresses there? What could this indicate about the geocoding process? Is it likely that the geocoder didn't recognize the exact address in its current-day database, and instead assigned it a generic midtown or uptown address based only on the street name.

Click on the hamburger icon at upper left to re-open the settings box, and then click on the pencil/edit icon next to the "Sales Locations" layer. Experiment with changing the tooltip to display the buyers instead, or one of the other variables in our dataset.

## Filtering by facet

Following the same process we used to facet the Table view, let's filter our map by facets. Try `buyer` first. Palladio will count up how many sales for each buyer are in the data set. Click on a single entry (like "Hilton, Henry") to filter the gallery to only display those. You'll notice some buyers show up with multiple addresses.

**You also may notice that some addresses haven't been properly geocoded by the automated service. Visualizing data like this can be a great way to catch data errors that are hard to spot in a spreadsheet.**

Click on the red trash basket icon on the lower right to dismiss the facet filter. (If the data visualization doesn't update automatically, try zooming in and out a bit and that will usually force it to update.)

### Filtering by timeline

Using the same timeline filter that we did with the Table view, try selecting one decade of sales on the timeline to filter the map down to that decade. You can drag the selection box along the timeline to dynamically update the map as you move from 1870 to 1970. Take note of the changing geographic distribution of buyers as you do this.

### Reflection questions

1. How did the geographic distribution of Knoedler's buyers change over the life of the firm between 1870 and 1970? What further historical questions does this suggest?

## Create networks

One of Knoedler's biggest impacts on the history of fine arts in the U.S. was how they funneled old master paintings from European sellers into American collections. We can use network visualizations to get a sense of what buyers were connected to what sellers, and how the shape of the "Knoedler network" changed over time. (As always, though, we need to bear in mind that this slice of the data set _only_ contains their New York buyers!)

Click on the "Graph" option. We need to specify the variables for the source and target dimensions - use `seller` and `buyer`, respectively.
Don't be surprised if your computer suddenly slows down for a few seconds: this is a very large network! It won't be helpful for us to try and look at the whole thing at once, so before continuing, click on the "Timeline" filter at the bottom of the screen and drag-select only a few years of relationships to show at one time. Back in the settings menu at the upper right, check the "Highlight" box for "source" (so our `sellers` get highlighted) and also check "Size nodes", which will adjust the size of each buyer/seller circle based on the total number of connections they have.

The resulting network from just a few years of sales should be much more manageable. Take a close look at the particularly prolific sellers - the entities that Knoedler purchased their stock from. What do you notice about the names? You'll find quite a few of them on Wikipedia - notice that they generally aren't single individuals, but are other art dealers!

Like we did with the map, see if you can find any patterns when filtering by time. You can also try graphing other types of entity relationships. For example, try setting the "Source" field to `artists` or `artist_nationality` while keeping the "Target" field set to `buyer`. This can give an impression of how different buyers may have targeted their purchases - or how Knoedler may have steered their assets to different parts of the market.

Finally, you may notice "Knoedler's" is in this network... but if this is only a network of people/institutions Knoedler _bought from_ and then _sold to_, why would they appear in the network? The answer can only be found by understanding the archival context:

![From the Getty Research Institute's description of the Knoedler Gallery Archive http://www.getty.edu/research/special_collections/notable/knoedler.html](img/knoedler_text.png)

Because of their many branches, Knoedler often makes entries that appear as though it's buying from itself! Depending on what kinds of questions we are asking, we might end up filtering out these sales from our data... or choose to inspect those records even more closely. Use a "Facet" by `seller` to try and show all sales _except_ the one where "Knoedler's" is the seller.

### Reflection questions

1. We encoded `seller_type` and `buyer_type` as part of the data to distinguish between individual collectors and artists vs. entities like dealers or museums. Try creating a network with the source being `seller_type` and the target being `buyer_type`. Try visualizing the changing network over time using the timeline facet. What do you notice about the changing preponderance of different buyer or seller types over time?
2. Experiment by setting the "Source" field to `artist`, `artist_nationality`, or `genre` - can you find collectors who seemed to buy lots of one particular nationality or genre? Conversely, can you find collectors who bought a very diverse set of works?
3. Remember that some of the artist names are actually labels for who nationalities, because the individual artist was unknown. What problems does this introduce for a network visualization connecting individual artists to buyers?

## Saving your visualizations

Although you cannot export interactive visualizations from Palladio, you can save static images based on your representations. In the Settings menus for any of the visualizations, click the "Download" button to generate a .svg image of your visualization.

## Other data sources and notes

With the right data set, Palladio can also display images, and do some fancy things like overlaying networks onto maps, and join multiple data tables together. Optionally, you can experiment with these possibilities [by using the Amsterdam depictions dataset from an earlier version of this workshop.][amsterdam_palladio]. This dataset includes links to images, which will let you try out Palladio's "Gallery" view, which can be very useful for examining subsets of your data and bringing your analyses back to the artwork.

Finally, remember that Palladio is a tool expressly designed for initial data explorations. Stanford's Humanities+Design lab specifically intends it to be the starting point of a project, after which you move into more specialized tools. Palladio has some pretty strict limits:

- It can only process a limited amount of data. If you go much over 10,000 rows, the program will become unusably slow.
- Composing very complicated queries to filter and aggregate your data can't be done in Palladio
- The visual minimalism is very good for prototyping visualizations, but if you need to use color then you'll need to expand into new software.

**Make sure to go back over the first set of reflection questions and add any further observations you had during this exercise about the dataset and what it shows vs. what it omits.**