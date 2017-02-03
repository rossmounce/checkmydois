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

# Put your ORCID ID below
orcid_data = rorcid::orcid_id(orcid_id)

get_status = function(url) {
  # Get the HTTP reponse status of a URL
  agent = "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.0; Trident/5.0; Trident/5.0)"
  agent = httr::user_agent(agent)
  response = httr::GET(url, agent)
  status = httr::http_status(response)
  return(status$message)
}

# Create a data_frame of orcid works and their HTTP status
works = rorcid::works(orcid_data)
work_df = works$data$`work-external-identifiers.work-external-identifier` %>%
  dplyr::bind_rows() %>%
  dplyr::filter(`work-external-identifier-type` == 'DOI') %>%
  dplyr::select(doi = `work-external-identifier-id.value`) %>%
  dplyr::distinct() %>%
  dplyr::arrange(doi) %>%
  dplyr::transmute(url = paste0('https://doi.org/', doi)) %>%
  dplyr::rowwise() %>%
  dplyr::mutate(status = get_status(url))

#Write out a list of DOIs for all your ORCID registered works
iso_timestamp = strftime(as.POSIXlt(Sys.time(), "UTC"), "%Y-%m-%dT%H:%M:%S")
print(iso_timestamp)

path = file.path('output', 'works.tsv')
readr::write_tsv(work_df, path)
