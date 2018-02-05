## Foreword

The following walkthrough was made for a [Networked Curator workshop given at the Getty Research Institute, February 8th, 2018](http://networkedcurator.doingdh.org/).

This lesson is derived from a [similar Palladio workshop given at the Frick Digital Art History Lab, April 8th, 2016][amsterdam_palladio].

[amserdam_palladio]: https://matthewlincoln.net/2016/04/07/exploring-depictions-of-amsterdam-with-palladio.html

# Introduction

Some tips from [Miriam Posner](http://miriamposner.com/blog/getting-started-with-palladio/) before we begin:

>A reminder that Palladio is still under development, so it can be buggy
and slow!
>
>-   Work slowly. Wait for an option to finish loading before you click it again or click something else.
>
>-   **Do not refresh the page.** You'll lose your work.
>
>-   On a related note: To start over, refresh the page.
>
>-   Clicking on the **Palladio** logo will bring you to the Palladio homepage, but it won't erase your work.

Another tip from me: while Palladio _mostly_ works with Firefox, some options like tooltips are a bit buggy in that browser. You'll find more consistent results using Chrome or Safari.

## Download the workshop data

[Download the CSV file that we'll work with.](https://matthewlincoln.net/mapping-knoedler-palladio/nyc_knoedler.csv)

These data describe a litte over 4,700 sales by the fine art dealer M. Knoedler & Co. between roughtly 1870-1970, as documented in their stockbooks data as encoded by the Getty Provenance Index.
In order to keep this introductory lesson straightforward, **this is only a tiny slice of the full Knoedler data**, which cover over 40,000 entries.
The data in `nyc_knoedler.csv` covers only those cases in which:

1. The transactions were recorded in the Knoedler stockbooks (they didn't always keep good records!)
2. Artworks for which we have the original purchase _and_ sale dates and prices.
3. The buyer has a known street address located in Manhattan or Brooklyn (i.e. if our only location info says "New York, NY", it is not included in this subset because it doesn't contain street-level precision. **Note: we haven't yet finished entering all the known addresses - bear this in mind when interpreting visualizations!**)

I've also enhanced these data with some important modifications that aren't included in the original Knoedler data:

1. Imputed values for partially-recorded purchase and sale dates, based on location in the archive.
2. To allow comparison of prices over time, I've converted monetary amounts from foreign currencies into USD, and deflated to a dollar value pinned to 1900.
3. Generated lat/lon coordinates for street addresses using the [DSK geocoding service](https://cran.r-project.org/web/packages/ggmap/).

For the sake of simplicity, I've drastically trimmed the number of variables for each of these transactions.
This means some complexities that _are_ represented in the Knoelder data, like transactions of multiple objects, as well as joint purchases by Knoedler and another dealer, are flattened here.

The columns in this table include:

field         | description
--------------|-------------------------------------------------------------------------
`title`   | Title of the work (if recorded)
`artists` | Creator(s) of the artwork (if recorded)
`artists_nationality` | Creator(s) nationalites(input by modern editors) 
`genre`  | Genre of the work (input by modern editors)
`object_type`  | e.g. `Painting`, `Drawing`, `Sculpture` (input by modern editors)
`height` | Height in inches (if recorded)
`width`   | Width in inches (if recorded)
`area`  | Area in square inches (if recorded)
`seller`  | Name of seller (numeric ID if anonymous/unknown)
`seller_type` | e.g. `Dealer`, `Museum`, `Artist`, `Collector`
`buyer` | Name of buyer (numeric ID if anonymous/unknown)
`buyer_type` | e.g. `Dealer`, `Museum`, `Artist`, `Collector`
`buyer_address`   | Buyer address
`coordinates`  | Coordinates in the format `lat,lon`
`purchase_date`  | Date object brought into Knoedler stock in the format `YYYY-MM-DD`
`sale_date` | Date object sold out of Knoedler stock in the format `YYYY-MM-DD`
`purchase_price`   | Price Knoedler paid to buy the object (in 1900 USD)
`sale_price`  |  Price Knoedler recieved for selling the object (in 1900 USD)

## Loading our data

Navigate to <http://palladio.designhumanities.org> and click on the "Start" button.

Drag the file `nyc_knoedler.csv` into the window where it says "Load .csv or spreadsheet". You should see text fill the box. Click load.

You should now see the data loaded into Palladio. Let's call our project name "Knoedler", and the table name "New York Sales".

## Checking our data

The data view shows the fields (i.e. columns) from our spreadsheet, and also shows what type of variable Palladio has guessed our data are supposed to be. We've got a few text fields here, as well as date fields, and a coordinates field.

Palladio tries to check for some simple irregularities in our data, like odd characters, and it's highlighted those fields with a red dot. We can ignore these dots for now, as all those characters (like commas or dashes in the _title_ field) are there on purpose.

We also have the option to set the Data Type of this field. Normally Palladio will recognize this automatically, but in some cases, we'll find that we need to manually set a field to "Date" when Palladio thinks it is only a "Number".

## Create a map

Now click on the "Map" button. Palladio starts you out with a plain coastline basemap. Before adding our own data, we can enhance this basemap by adding more "Tiles". Click on "New Layer", then click on the "Tiles" tab. You can see the different tile types to add to the basemap - let's add "Streets" by clicking on the "Streets" button. In the "Name" field above, type "Streets", then click "Add Layer". You should now see borders and cities showing up on your basemap.

Now it's time to add our own data. Click on "New Layer" again, and click the "Data" tab. We'll be adding "Points" (the default option). Click on "Places" and select `coordinates` (the only option). For the tooltip label (what we see when we roll over the points), let's start with `buyer_address`. Check the box to size points, and do so according to `number of New York Sales`. Finish by clicking "Add Layer", and then click on the hamburger button (the three small lines in the upper right corner) to minimize the layer configuration box.

You should see a few dots appearing over New York City. In the upper left corner, underneath the zoom in/out buttons, there's a button called "Zoom to data" - click on this to automatically zoom in so that our data points fill the screen.

Now we can start "faceting", or filtering the data based on different variables. Click on the "Facet" button on the lower left corner, and in the lower right corner, use the "Dimensions" menu to select which variable we want to facet by. Try `buyer` first. Palladio will count up how many sales for each buyer are in the dataset, and we can click on a single type to filter the gallery to just display those. You'll notice some buyers show up with multiple addresses. 

**You also may notice that some addresses haven't been properly geocoded by the automated service. Vsiualizing data like this can be a great way to catch data errors that are hard to spot in a spreadsheet.**

Click on the red trash basket icon on the lower right to dismiss the facet filter.

We can also use the "Timeline" filter to visualize and filter based on date. Palladio should already have recognized the `purchase_date` column and created a timeline for us. You can drag and select a particular range if you like, and then drag that range around to see which different objects show up in our view. Note that you can also chose a "group by" variable in the timeline, which will color the histogram based on that variable.

Palladio also understands _timespans_, or activities that have a start and end date. After dismissing the Timeline filter with the red trash basket button, click on "Timespan". We'll need to tell it the correct start date and end date columns. Now in addition to getting a map visualization, we'll also be able to visualize the tempo at which Knoelder rotate their stock. You can experiment with different timespan visualization techniques by changing the "Layout" menu.

Did the geographic distribution of Knoedler's buyers change over the life of the firm? How? In what ways did they change the pace at which they sold artworks? Are there any gaps in the visualizations that might point to data entry problems?

## Create networks

Our research project is interested in how Knoedler acted as a conduit for the art market, funneling old master paintings into American collections. We can use network visualizations to get a sense of what buyers were connected to what sellers, and how the shape of the "Knoedler network" chagned over time. (As always, though, we need to bear in mind that this slice of the dataset _just_ contains their New York buyers!)

Click on the "Graph" option. We need to specify the variables for the source and target dimension - use `seller` and `buyer`, respectively.
Don't be surprised if your computer suddenly slows down for a few seconds: this is a very large network! It won't be helpful for us to try and look at the whole thing at once, so before continuing, click on "Timeline" and select just a few years of relationships to show at one time.

Like we did with the map, see if you can find any patterns when filtering by time. You can also try graphing other types of entity relationships. For example, try setting the "Source" field to `artists` or `artist_nationality` while keeping the "Target" field set to `buyer`. This can give an impression of how different buyers may have targeted their purchases - or how Knoedler may have steered their assets to different parts of the market.

## Saving your visualizations

Although you cannot export interactive visualizations from Palladio, you can save static images based on your representations. In the Settings menus for any of the visualizations, click the "Download" button to generate an .svg image of your visualization.

## Work on your own

With the right dataset, Palladio can also display images, and do some fancy things like overlaying networks onto maps, and join multiple data tables together. To experiment with these possibilities, [try out the Amsterdam depictions dataset from an earlier version of this workshop.][amserdam_palladio]

While a great tool for initial explorations, Palladio has some pretty strict limits. Try <plot.ly> if you are looking for more fine-grained control over your charts, or need to ask more complicated questions.