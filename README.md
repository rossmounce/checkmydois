# checkmydois: Check the HTTP status of your DOIs

R code to check that the DOIs of your own authored research outputs (not just articles!) aren't 404'ing.
This leverages your ORCID profile and your list of public works. (Public works only)

## Usage

Run the script from this directory using either of the following two methods:

1. Pass your ORCID as an argument to the R script:

  ```sh
  Rscript checkmydois.R "0000-0002-3520-2046"
  ```

2. Set your ORCID as an environment variable

  ```sh
  export ORCID_ID="0000-0002-3520-2046"
  Rscript checkmydois.R
  ```

## Dependencies

See the `Imports` section of [`DESCRIPTION`](DESCRIPTION) for a list of required packages.

## Future

To be implemented: 

+ check that your research outputs that _should_ be openly accessible, actually are openly accessible, i.e. for a research article that not only does the DOI resolve to the correct landing page, but that the fulltext of the article is available from that landing page.

+ Email you if a DOI returns a 404

+ Scheduled / automated execution

Thanks to Scott Chamberlain for helping me get the output I wanted from `rorcid`
