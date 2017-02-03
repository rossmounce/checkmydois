#!/usr/bin/env Rscript

# Load magrittr pipe
`%>%` = dplyr::`%>%`

# Get user's ORCID identifier
command_args = commandArgs(trailingOnly = TRUE)
if (length(command_args) > 0) {
  # If command arguments were passed, assume first argument is orcid_id
  orcid_id = command_args[1]
} else {
  # If no argument, look for the system variable ORCID_ID
  orcid_id = Sys.getenv('ORCID_ID', unset = NA)
}
if (is.na(orcid_id)) {
  stop("orcid_id is not set. Cannot continue with missing orcid_id.")
}
print(paste0('orcid_id set to ', orcid_id))

# Retreive ORCID data
orcid_data = rorcid::orcid_id(orcid_id)
works = rorcid::works(orcid_data)

get_status = function(url) {
  # Get the HTTP reponse status of a URL
  agent = "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.0; Trident/5.0; Trident/5.0)"
  agent = httr::user_agent(agent)
  response = httr::GET(url, agent)
  status = httr::http_status(response)
  return(status$message)
}

# Extract a data_frame where each row is a work
work_df = works$data %>%
  dplyr::filter(! sapply(`work-external-identifiers.work-external-identifier`, is.null)) %>%
  tidyr::unnest(`work-external-identifiers.work-external-identifier`) %>%
  dplyr::filter(`work-external-identifier-type` == 'DOI') %>%
  dplyr::rename(
    doi = `work-external-identifier-id.value`,
    journal = `journal-title.value`,
    year = `publication-date.year.value`
    ) %>%
  dplyr::distinct(doi, .keep_all=TRUE) %>%
  dplyr::arrange(doi) %>%
  dplyr::mutate(url = paste0('https://doi.org/', doi)) %>%
  dplyr::rowwise() %>%
  dplyr::mutate(status = get_status(url)) %>%
  dplyr::select(url, status, journal, year)

# Export work_df to TSV
iso_timestamp = strftime(as.POSIXlt(Sys.time(), "UTC"), "%Y-%m-%dT%H:%M:%S")
print(iso_timestamp)

path = file.path('output', 'works.tsv')
readr::write_tsv(work_df, path, na='')
