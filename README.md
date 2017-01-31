# checkmydois
R code to check that the DOIs of your own authored research outputs (not just articles!) aren't 404'ing.
This leverages your ORCID profile and your list of public works. (Public works only)

R package Dependencies:

`httr`
`dplyr`
`rorcid`



To be implemented: 

* check that your research outputs that _should_ be openly accessible, actually are openly accessible, i.e. for a research article that not only does the DOI resolve to the correct landing page, but that the fulltext of the article is available from that landing page.

* Email you if a DOI returns a 404

Thanks to Scott Chamberlain for helping me get the output I wanted from `rorcid`

##Scheduling this as a cron job 

I have this script setup so it runs daily on my machine at 5.15am local time 
```
15 5 * * * Rscript /path/to/file/checkmydois.R
```
